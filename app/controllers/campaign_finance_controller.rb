# frozen_string_literal: true

require 'faraday'
require 'json'
class CampaignFinanceController < ApplicationController
  def index
    @campaign_finances = CampaignFinance.all
    @cycles = CampaignFinance.cycles
    @categories = CampaignFinance.categories
  end

  def search
    search_params = { cycle: params[:cycle], category: params[:category] }
    @category_key = CampaignFinance.categories[search_params[:category]]
    @campaign_finances = CampaignFinance.find_from_top_twenty(search_params)
  end
end
