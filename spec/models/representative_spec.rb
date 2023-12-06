# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

describe Representative do
  it 'is valid with valid attributes' do
    representative = described_class.new(
      name:            'John Doe',
      ocdid:           'ocd-division/country:us',
      title:           'Senator',
      street:          '123 Main St',
      city:            'Anytown',
      state:           'CA',
      zip:             '12345',
      political_party: 'Independent',
      photo:         'example.com'
    )
    expect(representative).to be_valid
  end

  describe 'civic api to representative params' do
    before do
      @rep_info = instance_double('rep_info')
      @existing_rep = described_class.create!(name: 'Chris Traeger',
                                              ocdid: 'ocd-division/country:us/state:ca/place:example_city', title: 'Clerk')
    end

    it 'creates representatives from rep_info' do
      allow(@rep_info).to receive(:officials).and_return([
                                                           instance_double('official1', name: 'John Doe', address: nil, party: nil, photo_url: 'http://example.com/photo1.jpg'),
                                                           instance_double('official2', name: 'Jane Smith', address: nil, party: nil, photo_url: 'http://example.com/photo1.jpg')
                                                         ])

      allow(@rep_info).to receive(:offices).and_return([
                                                         instance_double('office1', name: 'Mayor', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city'),
                                                         instance_double('office2', name: 'Governor', official_indices: [1],
division_id: 'ocd-division/country:us/state:ca')
                                                       ])
      reps = Representative.civic_api_to_representative_params(@rep_info)
      expect(reps.size).to eq(2)
      expect(reps[0].attributes).to include(
        'name'            => 'John Doe',
        'ocdid'           => 'ocd-division/country:us/state:ca/place:example_city',
        'title'           => 'Mayor',
        'street'          => "",
        'city'            => "",
        'state'           => "",
        'zip'             => "",
        'political_party' => "",
        'photo'           => 'http://example.com/photo1.jpg'
      )
      expect(reps[1].attributes).to include(
        'name'            => 'Jane Smith',
        'ocdid'           => 'ocd-division/country:us/state:ca',
        'title'           => 'Governor',
        'street'          => "",
        'city'            => "",
        'state'           => "",
        'zip'             => "",
        'political_party' => "",
        'photo'           => 'http://example.com/photo1.jpg'
      )
      reps.each do |rep|
        if rep.new_record?
          expect(rep).to receive(:save!)
          rep.save!
        end
      end

    end

    it 'doesnt duplicate representatives' do
      allow(@rep_info).to receive(:officials).and_return([
                                                           instance_double('official1', name: 'Chris Traeger', address: nil, party: nil, photo_url: nil)
                                                         ])

      allow(@rep_info).to receive(:offices).and_return([
                                                         instance_double('office1', name: 'Clerk', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city')
                                                       ])
      expect(Representative).to receive(:find_or_initialize_by).with(
        name: 'Chris Traeger',
        ocdid: 'ocd-division/country:us/state:ca/place:example_city'
      ).and_return(@existing_rep)

      expect(@existing_rep).to receive(:new_record?).and_return(false)
      expect(@existing_rep).to receive(:changed?).and_return(true)
      expect(@existing_rep).to receive(:save!)
      reps = described_class.civic_api_to_representative_params(@rep_info)
      expect(reps.first).to eq(@existing_rep)

    end
  end
end