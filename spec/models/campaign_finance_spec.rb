# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignFinance, type: :model do
  describe '.cycles' do
    it 'returns an array of years from 2010 to 2020' do
      expect(described_class.cycles).to eq((2010..2020).to_a)
    end
  end

  describe '.categories' do
    expected_keys = %w[candidate-loan contribution-total debts-owed disbursements-total
                       end-cash individual-total pac-total receipts-total refund-total]

    it 'returns the correct categories hash' do
      expect(described_class.categories.keys).to contain_exactly(*expected_keys)
    end
  end
end
