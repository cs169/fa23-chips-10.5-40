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
      profile:         'example.com'
    )
    expect(representative).to be_valid
  end

  describe 'civic api to representative params' do
    before do
      @rep_info = double('rep_info')
      @existing_rep = described_class.create!(name: 'Chris Traeger',
                                              ocdid: 'ocd-division/country:us/state:ca/place:example_city', title: 'Clerk')
    end

    it 'creates representatives from rep_info' do
      allow(@rep_info).to receive(:officials).and_return([
                                                           double('official1', name: 'John Doe', address: nil, party: nil, photoUrl: nil),
                                                           double('official2', name: 'Jane Smith', address: nil, party: nil, photoUrl: nil)
                                                         ])

      allow(@rep_info).to receive(:offices).and_return([
                                                         double('office1', name: 'Mayor', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city'),
                                                         double('office2', name: 'Governor', official_indices: [1],
division_id: 'ocd-division/country:us/state:ca')
                                                       ])

      expect(described_class).to receive(:create!).with({
                                                          name:            'John Doe',
                                                          ocdid:           'ocd-division/country:us/state:ca/place:example_city',
                                                          title:           'Mayor',
                                                          street:          '',
                                                          city:            '',
                                                          state:           '',
                                                          zip:             '',
                                                          political_party: '',
                                                          profile:         ''
                                                        })
      expect(described_class).to receive(:create!).with({
                                                          name:            'Jane Smith',
                                                          ocdid:           'ocd-division/country:us/state:ca',
                                                          title:           'Governor',
                                                          street:          '',
                                                          city:            '',
                                                          state:           '',
                                                          zip:             '',
                                                          political_party: '',
                                                          profile:         ''
                                                        })

      described_class.civic_api_to_representative_params(@rep_info)
    end

    it 'doesnt duplicate representatives' do
      allow(@rep_info).to receive(:officials).and_return([
                                                           double('official1', name: 'Chris Traeger', address: nil, party: nil, photoUrl: nil)
                                                         ])

      allow(@rep_info).to receive(:offices).and_return([
                                                         double('office1', name: 'Clerk', official_indices: [0],
division_id: 'ocd-division/country:us/state:ca/place:example_city')
                                                       ])

      expect(@existing_rep).not_to receive(:update!)
      expect(described_class).not_to receive(:create!)

      described_class.civic_api_to_representative_params(@rep_info)
    end
  end
end
