# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe SearchController, type: :controller do
  describe 'search' do
    before do
      stub_request(:get, 'https://civicinfo.googleapis.com/civicinfo/v2/representatives')
        .with(query: hash_including({ address: 'Los Angeles' })) # http mock
        .to_return(
          status:  200,
          body:    fake_civic_info_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      get :search, params: { address: 'Los Angeles' }
      @representative = assigns(:representatives)
    end

    it 'assigns @representatives to not be nil' do
      expect(@representative).not_to be_nil
    end
  end

  def fake_civic_info_response
    {
      offices:   [],
      officials: [
        { name:    'John Doe',
          address: [{ address: '123 Main St', state: 'CA', city: 'Los Angeles', zip: '11111' }],
          party:   'Democratic' }
      ]
    }
  end
end
