require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context 'unauthorized user' do
    describe 'GET index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns http success with a topic id' do
        get :index, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET show' do
      it 'returns http success' do
        get :show, id: my_post.id
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'authorized user' do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    describe 'GET index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns http success with a topic id' do
        get :index, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET show' do
      it 'returns http success' do
        get :show, id: my_post.id
        expect(response).to have_http_status(:success)
      end
    end
  end
end
