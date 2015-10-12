require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create!( name: 'Bloc Head',  email: 'blochead@bloc.io', password: 'password' ) }

  describe 'GET new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status :success
    end
  end

  describe 'POST sessions' do
    it 'returns http success' do
      post :create, session: { email: user.email }
      expect(response).to have_http_status :success
    end

    it 'initializes a session' do
      post :create, session: { email: user.email, password: user.password }
      expect(assigns(:sessions)) == user.id
    end

    it 'does not initialize session due to missing password' do
      post :create, session: { email: user.email }
      expect(assigns(:session)).to be_nil
    end

    it 'flashes #error with bad email address' do
      post :create, session: { email: 'does not exist' }
      expect(flash[:error]).to be_present
    end

    it 'render #new with bad email address' do
      post :create, session: { email: 'does not exist' }
      expect(response).to render_template :new
    end

    it 'renders the #show view with valid email address' do
      post :create, session: { email: user.email, password: user.password }
      expect(response).to render_template :new
    end
  end

  describe 'DELETE sessions/id' do
    it 'renders the #welcome view' do
      delete :destroy, id: user.id
      expect(response).to redirect_to root_path
    end

    it 'deletes the user\'s session' do
      delete :destroy, id: user.id
      expect(assigns(:session)).to be_nil
    end

    it 'flashes #notice' do
      delete :destroy, id: user.id
      expect(flash[:notice]).to be_present
    end
  end
end
