require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }
  let(:my_comment) { Comment.create!(body: 'Comment Body', post: my_post, user: my_user) }

  context 'unauthorized user' do
    describe 'GET index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns http success with post id' do
        get :index, post_id: my_post.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET show' do
      it 'returns http success' do
        get :show, post_id: my_post.id, id: my_comment.id
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

      it 'returns http success with post id' do
        get :index, post_id: my_post.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET show' do
      it 'returns http success' do
        get :show, post_id: my_post.id, id: my_comment.id
        expect(response).to have_http_status(:success)
      end
    end
  end
end
