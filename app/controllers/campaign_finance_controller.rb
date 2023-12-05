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
    @campaign_finances = CampaignFinance.find_from_top_twenty(params[:search])
  end
end
    