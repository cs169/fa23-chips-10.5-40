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
  describe 'GET #search' do
    let(:valid_params) { { cycle: '2020', category: 'candidate-loan' } }

    context 'when valid parameters are provided' do
      before do
        allow(CampaignFinance).to receive(:find_from_top_twenty).and_return(['some', 'results'])
        get :search, params: valid_params
      end

      it 'calls CampaignFinance.find_from_top_twenty with correct parameters' do
        expect(CampaignFinance).to have_received(:find_from_top_twenty).with(valid_params)
      end

      it 'assigns @campaign_finances' do
        expect(assigns(:campaign_finances)).to eq(['some', 'results'])
      end

      it 'assigns @category_key' do
        expect(assigns(:category_key)).to eq('candidate_loans')
      end
    end

    context 'when invalid parameters are provided' do
      before do
        get :search, params: { cycle: '2020', category: 'invalid-category' }
      end

      it 'handles missing or invalid parameters appropriately' do
        # Your test code here
      end
    end
  end

end
