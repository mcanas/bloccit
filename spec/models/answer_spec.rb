require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'attributes' do
    let(:question) { Question.create!(title: 'New question title', body: 'New question body') }
    let(:answer) { Answer.create!(body: 'New answer body', question: question) }

    it 'should respond to body' do
      expect(answer).to respond_to(:body)
    end
  end
end
