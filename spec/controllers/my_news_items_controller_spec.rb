# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  let(:user) do
    User.create!(
      first_name: 'John',
      last_name: 'Doe',
      uid: 'UID1',
      provider: :google_oauth2
    )
  end

  let(:representative) do
    Representative.create!(
      name: 'John Doe',
      ocdid: 'ocd-division/country:us/state:example',
      title: 'Position Title',
      street: '123 Main St',
      city: 'Anytown',
      state: 'State',
      zip: '12345',
    )
  end

  let(:valid_attributes) do
    {
      title: 'Sample Title',
      description: 'Sample Description',
      link: 'https://example.com',
      representative_id: representative.id,
      issue: 'Sample Issue'
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      description: 'Sample Description',
      link: 'https://example.com',
      representative_id: representative.id,
      issue: 'Sample Issue'
    }
  end

  before do
    session[:current_user_id] = user.id
  end

  describe 'GET #new' do
    it 'assigns news_item as @news_item' do
      get :new, params: { representative_id: representative.id }
      expect(assigns(:news_item)).to be_a_new(NewsItem)
    end
  end

  describe 'POST #create' do
    context 'have valid parameters' do
      it 'creates a new NewsItem' do
        expect do
          post :create, params: { representative_id: representative.id, news_item: valid_attributes }
        end.to change(NewsItem, :count).by(1)
      end

      it 'assigns a new news_item as @news_item' do
        post :create, params: { representative_id: representative.id, news_item: valid_attributes }
        expect(assigns(:news_item)).to be_a(NewsItem)
        expect(assigns(:news_item)).to be_persisted
      end

      it 'redirects to the created news_item' do
        post :create, params: { representative_id: representative.id, news_item: valid_attributes }
        expect(response).to redirect_to(representative_news_item_path(representative, assigns(:news_item)))
      end
    end  
  end

  describe 'PUT #update' do
    let!(:news_item) do
      NewsItem.create!(
        valid_attributes.merge(representative: representative)
      )
    end

    context 'have valid parameters' do
      it 'updates request news_item' do
        new_attributes = { title: 'New Title' }
        put :update, params: { id: news_item.id, news_item: new_attributes, representative_id: representative.id }
        news_item.reload
        expect(news_item.title).to eq('New Title')
      end

      it 'assigns request news_item as @news_item' do
        put :update, params: { id: news_item.id, news_item: valid_attributes, representative_id: representative.id }
        expect(assigns(:news_item)).to eq(news_item)
      end

      it 'redirects to the news_item' do
        put :update, params: { id: news_item.id, news_item: valid_attributes, representative_id: representative.id }
        expect(response).to redirect_to(representative_news_item_path(representative, news_item))
      end
    end   
  end
end
