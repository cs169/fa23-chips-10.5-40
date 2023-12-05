# frozen_string_literal: true

require 'faraday'
require 'json'
class CampaignFinanceController < ApplicationController

  def index
    @cycles = (2010..2020).step(2).to_a
    @categories = [
      'candidate-loan', 'contribution-total', 'debts-owed', 'disbursements-total',
      'end-cash', 'individual-total', 'pac-total', 'receipts-total', 'refund-total'
    ]
  end

  def search
    results = CampaignFinance.find_from_top_twenty(params[:search])
    @campaign_finances = CampaignFinance.propublica_api_to_campaign_finance_params(results, params[:search][:cycle], params[:search][:category])
  end
end
    