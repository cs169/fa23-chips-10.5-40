# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

describe Representative do
  it 'is valid with attributes' do
    representative = build_representative_with_attributes
    expect(representative).to be_valid
  end

  describe 'civic api to representative params' do
    before do
      @rep_info = instance_double('RepInfo')
      @existing_rep = described_class.create!(name:  'Chris Traeger',
                                              ocdid: 'ocd-division/country:us/state:ca/place:example_city',
                                              title: 'Clerk')
    end

    it 'creates representatives' do
      setup_rep_info_officials_and_offices
      reps = described_class.civic_api_to_representative_params(@rep_info)
      expect_reps_to_be_created_correctly(reps)
    end

    it 'doesnt duplicate representatives' do
      setup_rep_info_for_existing_rep
      reps = described_class.civic_api_to_representative_params(@rep_info)
      expect(reps.first).to eq(@existing_rep)
    end
  end

  def setup_rep_info_officials_and_offices
    allow(@rep_info).to receive(:officials).and_return([
                                                         instance_double('Official', name: 'John Doe', address: nil,
party: nil, photo_url: 'http://example.com/photo1.jpg'),
                                                         instance_double('Official', name: 'Jane Smith', address: nil,
party: nil, photo_url: 'http://example.com/photo2.jpg')
                                                       ])

    allow(@rep_info).to receive(:offices).and_return([
                                                       instance_double('Office', name: 'Mayor', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city'),
                                                       instance_double('Office', name: 'Governor', official_indices: [1],
                                                 division_id: 'ocd-division/country:us/state:ca')
                                                     ])
  end

  def setup_rep_info_for_existing_rep
    allow(@rep_info).to receive(:officials).and_return([
                                                         instance_double('Official', name: 'Chris Traeger', address: nil,
party: nil, photo_url: nil)
                                                       ])

    allow(@rep_info).to receive(:offices).and_return([
                                                       instance_double('Office', name: 'Clerk', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city')
                                                     ])

    allow(described_class).to receive(:find_or_initialize_by).and_return(@existing_rep)
    allow(@existing_rep).to receive(:new_record?).and_return(false)
    allow(@existing_rep).to receive(:changed?).and_return(true)
  end

  def build_representative_with_attributes
    described_class.new(
      name:            'John Doe',
      ocdid:           'ocd-division/country:us',
      title:           'Senator',
      street:          '123 Main St',
      city:            'Anytown',
      state:           'CA',
      zip:             '12345',
      political_party: 'Independent',
      photo:           'example.com'
    )
  end

  def setup_rep_info_and_existing_rep
    @rep_info = instance_double('RepInfo')
    @existing_rep = described_class.create!(
      name:  'Chris Traeger',
      ocdid: 'ocd-division/country:us/state:ca/place:example_city',
      title: 'Clerk'
    )
  end

  def expect_reps_to_be_created_correctly(reps)
    expect(reps.size).to eq(2)
    expect_rep_attributes(reps[0], 'John Doe', 'ocd-division/country:us/state:ca/place:example_city', 'Mayor', 'http://example.com/photo1.jpg')
    expect_rep_attributes(reps[1], 'Jane Smith', 'ocd-division/country:us/state:ca', 'Governor', 'http://example.com/photo2.jpg')

    reps.each do |rep|
      expect(rep).to have_received(:save!) if rep.new_record?
    end
  end

  def expect_rep_attributes(rep, name, ocdid, title, photo_url)
    expect(rep.attributes).to include(
      'name'            => name,
      'ocdid'           => ocdid,
      'title'           => title,
      'street'          => nil,
      'city'            => nil,
      'state'           => nil,
      'zip'             => nil,
      'political_party' => "",
      'photo'           => photo_url
    )
  end
end
