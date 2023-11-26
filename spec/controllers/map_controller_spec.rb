# frozen_string_literal: true

# spec/controllers/map_controller_spec.rb

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    # assigns @states to all the states and the @states_by_fips_code to its fips code
    it 'assigns @states and @states_by_fips_code' do
      get :index
      states = State.all
      expect(assigns(:states)).to eq(states)
      expect(assigns(:states_by_fips_code)).to eq(states.index_by(&:std_fips_code))
    end
  end

  describe 'GET #state' do
    # for county_details
    let(:state) { instance_double(State, symbol: 'CA', counties: []) }

    before do
      allow(State).to receive(:find_by).and_return(state)
    end

    it 'assigns @state' do
      get :state, params: { state_symbol: state.symbol }
      expect(assigns(:state)).to eq(state)
      expect(response).to render_template(:state)
    end

    context 'when state does not exist' do
      before do
        allow(State).to receive(:find_by).and_return(nil)
      end

      it 'redirects to root_path with an alert' do
        get :state, params: { state_symbol: 'nonexistent' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("State 'NONEXISTENT' not found.")
      end
    end
  end

  describe 'GET #county' do
    let(:los_angeles_county) { instance_double(County, std_fips_code: '12345', name: 'Los Angeles County') }
    let(:state) { instance_double(State, id: 1, symbol: 'CA', counties: [los_angeles_county]) }

    before do
      allow(State).to receive(:find_by).and_return(state)
      allow(controller).to receive(:get_requested_county).and_return(los_angeles_county)
    end

    it 'assigns @county and renders the county template' do
      get :county, params: { state_symbol: state.symbol, std_fips_code: los_angeles_county.std_fips_code }
      expect(assigns(:state)).to eq(state)
      expect(assigns(:county)).to eq(los_angeles_county)
      expect(response).to render_template(:county)
    end

    context 'when state does not exist' do
      before do
        allow(State).to receive(:find_by).and_return(nil)
      end

      it 'redirects to root_path with an alert' do
        get :county, params: { state_symbol: 'nonexistent', std_fips_code: '12345' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("State 'NONEXISTENT' not found.")
      end
    end

    context 'when county does not exist' do
      before do
        allow(State).to receive(:find_by).and_return(state)
        allow(controller).to receive(:get_requested_county).and_return(nil)
      end

      it 'redirects to root_path with an alert when county does not exist' do
        get :county, params: { state_symbol: state.symbol, std_fips_code: '12345' }
        puts flash.inspect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("County with code '12345' not found for #{state.symbol}")
      end
    end
  end
end
