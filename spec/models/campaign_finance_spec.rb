# frozen_string_literal: true

require 'rails_helper'

describe CampaignFinance do
  describe '.propublica_api_to_campaign_finance_params' do
    before do
      @rep_info = double('rep_info')
    end

    it 'creates campaign finance entries from rep_info results' do
      allow(@rep_info).to receive(:results).and_return([
        { 'name' => 'GARDNER, CORY', 'total_from_individuals' => '3527890.7', 'total_from_pacs' => '1706367.74' },
        { 'name' => 'PETERS, GARY', 'total_from_individuals' => '4908369.62', 'total_from_pacs' => '1505646.46' }
      ])

      expect { CampaignFinance.propublica_api_to_campaign_finance_params(@rep_info.results, '2020', 'individual-total') }
        .to change { CampaignFinance.count }.by(2)

      record1 = CampaignFinance.find_by(name: 'GARDNER, CORY')
      record2 = CampaignFinance.find_by(name: 'PETERS, GARY')

      expect(record1.cycle).to eq('2020')
      expect(record1.category).to eq('3527890.7')
      expect(record2.cycle).to eq('2020')
      expect(record2.category).to eq('4908369.62')
    end
  end
end
