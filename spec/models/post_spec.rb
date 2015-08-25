require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { Post.create!(title: 'New Post Title', body: 'New Post Body') }

  context 'attributes' do
    it 'should respond to title' do
      expect(post).to respond_to(:title)
    end

    it 'should respond to body' do
      expect(post).to respond_to(:body)
    end
  end
end
