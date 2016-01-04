require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }

  context 'unauthorized user' do
    it 'GET index returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'GET show returns http success' do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end
  end

  context 'unauthorized user' do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it 'GET index returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'GET show returns http success' do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end
  end
end
