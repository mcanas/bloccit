require 'rails_helper'
include RandomData

RSpec.describe AdvertisementsController, type: :controller do

  let(:test_advertisement) { Advertisement.create!({ title: RandomData.random_sentence, copy: RandomData.random_paragraph, price: RandomData.random_integer }) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns [test_advertisement] to @advertisements' do
      get :index
      expect(assigns(:advertisements)).to eq([test_advertisement])
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, id: test_advertisement.id
      expect(response).to have_http_status(:success)
    end

    it 'renders the #show view' do
      get :show, id: test_advertisement.id
      expect(response).to render_template :show
    end

    it 'assigns test_advertisement to @advertisement' do
      get :show, id: test_advertisement.id
      expect(assigns(:advertisement)).to eq(test_advertisement)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'renders the #new view' do
      get :new
      expect(response).to render_template :new
    end

    it 'instantiates a new @advertisement' do
      get :new
      expect(assigns(:advertisement)).not_to be_nil
    end
  end

  describe 'POST #create' do
    it 'increased the number of Advertisement by 1' do
      expect {
        post :create,
        advertisement: { title: RandomData.random_sentence, copy: RandomData.random_paragraph, price: RandomData.random_integer }
      }.to change(Advertisement, :count).by 1
    end

    it 'assigns the new advertisement to @advertisement' do
      post :create,
      advertisement: { title: RandomData.random_sentence, copy: RandomData.random_paragraph, price: RandomData.random_integer }
      expect(assigns(:advertisement)).to eq Advertisement.last
    end

    it 'it redirects to the new advertisement' do
      post :create,
      advertisement: { title: RandomData.random_sentence, copy: RandomData.random_paragraph, price: RandomData.random_integer }
      expect(response).to redirect_to Advertisement.last
    end
  end

end
