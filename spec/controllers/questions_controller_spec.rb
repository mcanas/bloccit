require 'rails_helper'
include RandomData

RSpec.describe QuestionsController, type: :controller do

  let(:test_question) { Question.create!({ title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_boolean }) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns [test_question] to @questions' do
      get :index
      expect(assigns(:questions)).to eq([test_question])
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, id: test_question.id
      expect(response).to have_http_status(:success)
    end

    it 'renders the #show view' do
      get :show, id: test_question.id
      expect(response).to render_template :show
    end

    it 'assigns test_question to @question' do
      get :show, id: test_question.id
      expect(assigns(:question)).to eq(test_question)
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

    it 'instantiates a new @question' do
      get :new
      expect(assigns(:question)).not_to be_nil
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, id: test_question.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'increased the number of Question by 1' do
      expect {
        post :create,
        question: { title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_boolean }
      }
    end

    it 'assigns the new question to @question' do
      post :create,
      question: { title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_boolean }
      expect(assigns(:question)).to eq Question.last
    end

    it 'redirects to the new question' do
      post :create,
      question: { title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_boolean }
      expect(assigns(:question)).to redirect_to Question.last
    end
  end

  describe 'PUT #update' do
    it 'updates @question with the expected attributes' do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_resolved = RandomData.random_boolean

      put :update, id: test_question.id, question: { title: new_title, body: new_body, resolved: new_resolved }

      updated_question = assigns(:question)
      expect(updated_question.id).to eq test_question.id
      expect(updated_question.title).to eq new_title
      expect(updated_question.body).to eq new_body
      expect(updated_question.resolved).to eq new_resolved
    end

    it 'redirects to the updated question' do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_resolved = RandomData.random_boolean

      put :update, id: test_question.id, question: { title: new_title, body: new_body, resolved: new_resolved }
      expect(response).to redirect_to test_question
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the question' do
      delete :destroy, id: test_question.id
      count = Question.where(id: test_question.id).size
      expect(count).to eq 0
    end

    it 'redirects to question index' do
      delete :destroy, id: test_question.id
      expect(response).to redirect_to questions_path
    end
  end
end
