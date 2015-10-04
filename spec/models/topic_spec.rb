require 'rails_helper'
include RandomData

RSpec.describe Topic, type: :model do
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph ) }

  it { should have_many(:posts) }

  describe 'attributes' do
    it 'should respond to name' do
      expect(topic).to respond_to :name
    end

    it 'should respond to description' do
      expect(topic).to respond_to :description
    end

    it 'should respond to public' do
      expect(topic).to respond_to :public
    end

    it 'should be public by default' do
      expect(topic.public).to be true
    end
  end
end
