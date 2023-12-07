# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignFinance, type: :model do
  describe '.cycles' do
    it 'returns an array of years from 2010 to 2020' do
      expect(described_class.cycles).to eq((2010..2020).select {|year| year.even?})
    end
  end

  describe '.categories' do
    expected_keys = %w[candidate-loan contribution-total debts-owed disbursements-total
                       end-cash individual-total pac-total receipts-total refund-total]

    it 'returns the correct categories hash' do
      expect(described_class.categories.keys).to contain_exactly(*expected_keys)
    end
  end

  describe '.find_from_top_twenty' do
    let(:search_params) { { cycle: '2020', category: 'candidate-loan' } }
    let(:response) { double('response') }

    context 'when API call is successful' do
      before do
        allow(response).to receive(:success?).and_return(true)
        allow(response).to receive(:body).and_return({ results: [{ name: 'John Doe', candidate_loans: 1000 }] }.to_json)
        allow(Faraday).to receive(:get).and_return(response)
      end

      it 'returns the data from the API' do
        results = CampaignFinance.find_from_top_twenty(search_params)
        expect(results).to eq([{ 'name' => 'John Doe', 'candidate_loans' => 1000 }])
      end
    end

    context 'when API call fails' do
      before do
        allow(response).to receive(:success?).and_return(false)
        allow(response).to receive(:body).and_return('{}')
        allow(Faraday).to receive(:get).and_return(response)
      end

      it 'returns an empty array' do
        expect(CampaignFinance.find_from_top_twenty(search_params)).to eq([])
      end
    end
    context 'when a Faraday::Error is raised' do

      before do
        allow(Faraday).to receive(:get).and_raise(Faraday::Error.new('Simulated Faraday Error'))
      end

      it 'rescues from Faraday::Error and returns an empty array' do
        expect(CampaignFinance.find_from_top_twenty(search_params)).to eq([])
      end
    end
  end
  
end
