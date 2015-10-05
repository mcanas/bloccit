require 'rails_helper'
include RandomData

RSpec.describe SponsoredPostsController, type: :controller do
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:sponsored_post) { topic.sponsored_posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: RandomData.random_integer) }

  describe 'GET #show' do
    it 'returns http success' do
      get :show, topic_id: topic.id, id: sponsored_post.id
      expect(response).to have_http_status(:success)
    end

    it 'renders the #show view' do
      get :show, topic_id: topic.id, id: sponsored_post.id
      expect(response).to render_template :show
    end

    it 'assigns sponsored_post to @sponsored_post' do
      get :show, topic_id: topic.id, id: sponsored_post.id
      expect(assigns[:sponsored_post]).to eq(sponsored_post)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, topic_id: topic.id
      expect(response).to have_http_status :success
    end

    it 'renders the #new view' do
      get :new, topic_id: topic.id
      expect(response).to render_template :new
    end

    it 'instantiates @sponsored_post' do
      get :new, topic_id: topic.id
      expect(assigns[:sponsored_post]).not_to be_nil
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, topic_id: topic.id, id: sponsored_post.id
      expect(response).to have_http_status(:success)
    end

    it 'renders the #edit view' do
      get :edit, topic_id: topic.id, id: sponsored_post.id
      expect(response).to render_template :edit
    end

    it 'assigns sponsored_post to be updated to @sponsored_post' do
      get :edit, topic_id: topic.id, id: sponsored_post.id
      sponsored_post_instance = assigns :sponsored_post
      expect(sponsored_post_instance.id).to eq(sponsored_post.id)
      expect(sponsored_post_instance.title).to eq(sponsored_post.title)
      expect(sponsored_post_instance.body).to eq(sponsored_post.body)
      expect(sponsored_post_instance.price).to eq(sponsored_post.price)
    end

    describe 'POST create' do
      it 'increased the number of Sponsored Post by 1' do
        expect { post :create, topic_id: topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: RandomData.random_integer } }.to change(SponsoredPost, :count).by(1)
      end

      it 'assigns the new sponsored_post to @sponsored_post' do
        post :create, topic_id: topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: RandomData.random_integer }

        expect(assigns(:sponsored_post)).to eq SponsoredPost.last
      end

      it 'redirects to the new sponsored post' do
        post :create, topic_id: topic.id, sponsored_post: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: RandomData.random_integer }

        expect(response).to redirect_to [topic, SponsoredPost.last]
      end
    end

    describe 'PUT update' do
      it 'updates sponsored post with expected attributes' do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_price = RandomData.random_integer

        put :update, topic_id: topic.id, id: sponsored_post.id, sponsored_post: { title: new_title, body: new_body, price: new_price }

        updated_sponsored_post = assigns(:sponsored_post)
        expect(updated_sponsored_post.id).to eq sponsored_post.id
        expect(updated_sponsored_post.title).to eq new_title
        expect(updated_sponsored_post.body).to eq new_body
      end

      it 'redirects to the updated post' do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_price = RandomData.random_integer

        put :update, topic_id: topic.id, id: sponsored_post.id, sponsored_post: { title: new_title, body: new_body, price: new_price }
        expect(response).to redirect_to [topic, sponsored_post]
      end
    end

    describe 'DELETE destroy' do
      it 'deletes the post' do
        delete :destroy, topic_id: topic.id, id: sponsored_post.id
        count = SponsoredPost.where(id: sponsored_post.id).size
        expect(count).to eq 0
      end

      it 'redirects to topic show' do
        delete :destroy, topic_id: topic.id, id: sponsored_post.id
        expect(response).to redirect_to topic
      end
    end

  end
end
