require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { Question.create!(title: 'New question title', body: 'New question body') }

  context 'attributes' do
    it 'should respond to title' do
      expect(question).to respond_to(:title)
    end

    it 'should respond to body' do
      expect(question).to respond_to(:body)
    end
  end
end
