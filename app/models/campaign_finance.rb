# frozen_string_literal: true

class CampaignFinance < ApplicationRecord
  def self.cycles
    (2010..2020).select {|year| year.even?}
  end

  def self.categories
    {
      'candidate-loan'      => 'candidate_loans',
      'contribution-total'  => 'total_contributions',
      'debts-owed'          => 'debts_owed',
      'disbursements-total' => 'total_disbursements',
      'end-cash'            => 'end_cash',
      'individual-total'    => 'total_from_individuals',
      'pac-total'           => 'total_from_pacs',
      'receipts-total'      => 'total_contributions',
      'refund-total'        => 'total_refunds'
    }
  end

  def self.find_from_top_twenty(search_params)
    key = '9lcjslvwVjbqtX0KcQQ3W9rFm316caQQ2T89n4xA'
    url = "https://api.propublica.org/campaign-finance/v1/#{search_params[:cycle]}/candidates/leaders/#{search_params[:category]}.json"

    begin
      response = Faraday.get(url) do |request|
        request.headers['X-API-Key'] = key
      end

      if response.success? && JSON.parse(response.body).key?('results')
        JSON.parse(response.body)['results']
      else
        Rails.logger.error "API call failed"
        [] 
      end
    rescue Faraday::Error => e
      Rails.logger.error "Failed to fetch data: #{e.message}"
      []
    end
  end
end
