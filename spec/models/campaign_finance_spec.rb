# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CampaignFinance, type: :model do
  describe '.propublica_api_to_campaign_finance_params' do
    let(:api_results) do
      {
        'status' => 'OK',
        'results' => [
          {
          'name' => 'DOE, JOHN',
          'candidate_loans' => 1000.0,
          'total_contributions' => 2000.0,
          'debts_owed' => 500.0,
          'total_disbursements' => 1500.0,
          'end_cash' => 2500.0,
          'total_from_individuals' => 1750.0,
          'total_from_pacs' => 250.0,
          'total_refunds' => 100.0,
        }
        ] 
      }
    end

    it 'creates or updates campaign finance records' do
      expect { CampaignFinance.propublica_api_to_campaign_finance_params(api_results['results'], '2020', 'candidate-loan') }
        .to change { CampaignFinance.count }.by(api_results['results'].size)
    end

    it 'correctly assigns attributes to campaign finance records' do
      CampaignFinance.propublica_api_to_campaign_finance_params(api_results['results'], '2020', 'candidate-loan')
      record = CampaignFinance.first

      expect(record.first_name).to eq('JOHN')
      expect(record.last_name).to eq('DOE')
      expect(record.candidate_loans).to eq(1000.0)

    end
  end
end