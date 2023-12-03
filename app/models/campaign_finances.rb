#frozen_string_literal: true

class CampaignFinance < ApplicationRecord

  def self.propublica_api_to_campaign_finance_params(results)
    campaign_finance_entries = []
    results.each do |result|
      name = result['name'].split(', ')
      first_name = name.last
      last_name = name.first
      entry = CampaignFinance.find_or_initialize_by(first_name: first_name, last_name: last_name)
      #where is receipts total? can't find it in the api response example
      entry.assign_attributes(
        candidate_loans: result['candidate_loans'],
        total_contributions: result['total_contributions'],
        debts_owed: result['debts_owed'],
        total_disbursements: result['total_disbursements'],
        end_cash: result['end_cash'],
        total_from_individuals: result['total_from_individuals'],
        total_from_pacs: result['total_from_pacs'],
        total_refunds: result['total_refunds'],
      )
      entry.save!
      ret.push(entry)
    end
    campaign_finance_entries
  end
end
