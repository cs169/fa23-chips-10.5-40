# frozen_string_literal: true

class CampaignFinance < ApplicationRecord
  has_many :news_items, dependent: :delete_all


  def self.cycles
    (2010..2020).to_a
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
    url = "https://api.propublica.org/campaign-finance/v1/#{search_params[:cycle]}/candidates/leaders/#{categories[search_params[:category]]}"
    response = Faraday.get(url) do |request|
      request.headers['X-API-Key'] = key
    end
    JSON.parse(response.body)['results']
  end
end