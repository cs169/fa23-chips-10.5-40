# frozen_string_literal: true

require 'faraday'
require 'json'
class CampaignFinanceController < ApplicationController

  def index
  end

  def search
    cycle = params[:cycle]
    raise 'invalid cycle' unless cycle.match(/\A20\d{2}\z/) && cycle.to_i.even? && cycle.to_i.between?(2010,2020)
    category = params[:category]
    raise 'invalid category' unless
    [
      'candidate-loan', 'contribution-total', 'debts-owed', 'disbursements-total',
    'end-cash', 'individual-total', 'pac-total', 'receipts-total', 'refund-total'
    ].include?(category)
    #     Get Top 20 Candidates in Specific Financial Category
    # This endpoint retrieves the top 20 candidates within a given financial category for a given campaign cycle. The possible values are listed below.
    # HTTP Request
    # GET https://api.propublica.org/campaign-finance/v1/{cycle}/candidates/leaders/{category}
    # URL Parameters
    # Parameter	Description
    # cycle	Four-digit even-numbered year between 2010 and 2020

    url = "https://api.propublica.org/campaign-finance/v1/#{cycle}/candidates/leaders/#{category}.json"
    headers = { 'X-API-Key' => '9lcjslvwVjbqtX0KcQQ3W9rFm316caQQ2T89n4xA' }
    conn = Faraday.new do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    response = JSON.parse(conn.get(url, nil, headers).body)
    raise "API call failed with #{response.status}" if response['status'] != 'OK'

    results = response['results']
    @campaign_finance = CampaignFinance.propublica_api_to_campaign_finance_params(results)
    render 'campaign_finance/search'
    rescue StandardError =>e
      flash[:error] = e.message
      redirect_to action: :index
    end
  end
end
    