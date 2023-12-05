# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignFinanceController, type: :controller do
  describe 'GET #index' do
    it 'assigns @campaign_finances and renders the index template' do
      get :index
      expect(assigns(:campaign_finances)).to eq(CampaignFinance.all)
      expect(assigns(:cycles)).to eq(CampaignFinance.cycles)
      expect(assigns(:categories)).to eq(CampaignFinance.categories)
      expect(response).to render_template(:index)
    end
  end
end