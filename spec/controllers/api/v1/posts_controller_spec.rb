require 'rails_helper'
include RandomData

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_other_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context 'unauthenticated user' do
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

    it 'PUT update returns http unauthenticated' do
      put :update, id: my_post.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph }
      expect(response).to have_http_status(401)
    end

    it 'POST create returns http unauthenticated' do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph }
      expect(response).to have_http_status(401)
    end

    it 'DELETE destroy returns http unauthenticated' do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context 'unauthorized user' do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_other_user.auth_token)
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

    it 'GET show returns http success' do
      get :show, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it 'POST create returns http success' do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph }
      expect(response).to have_http_status(403)
    end

    it 'PUT update returns http unauthorized' do
      put :update, user_id: my_other_user.id, id: my_post.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph }
      expect(response).to have_http_status(403)
    end

    it 'DELETE destroy returns http unauthorized' do
      delete :destroy, user_id: my_other_user.id, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context 'authorized user' do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_post = build(:post, topic: my_topic, user: my_user)
    end

    describe 'PUT update' do
      before do
        put :update, id: my_post.id, post: { title: @new_post.title, body: @new_post.body }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content type' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'updates a post with the correct attributes' do
        updated_post = Post.find(my_post.id)
        expect(updated_post.to_json).to eq response.body
      end
    end

    describe 'POST create' do
      before do
        post :create, topic_id: my_topic.id, post: { title: @new_post.title, body: @new_post.body }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content type' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'creates a post with the correct attributes' do
        hashed_json = JSON.parse(response.body)
        expect(@new_post.title).to eq(hashed_json['title'])
        expect(@new_post.body).to eq(hashed_json['body'])
      end
    end

    describe 'DELETE destroy' do
      before do
        delete :destroy, id: my_post.id
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content type' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns the correct json message' do
        expect(response.body).to eq({ message: 'Post destroyed', status: 200 }.to_json)
      end

      it 'deletes my_post' do
        expect { Post.find(my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
