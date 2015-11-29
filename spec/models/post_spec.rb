require 'rails_helper'
include RandomData

RSpec.describe Post, type: :model do
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph ) }
  let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
  let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }

  it { should have_many(:labelings) }
  it { should have_many(:labels).through(:labelings) }

  it { should belong_to(:topic) }
  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should have_many(:votes) }
  it { should have_many(:favorites) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:user) }

  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(20) }

  describe 'attributes' do
    it 'should respond to title' do
      expect(post).to respond_to(:title)
    end

    it 'should respond to body' do
      expect(post).to respond_to(:body)
    end
  end

  describe 'voting' do
    before do
      3.times { post.votes.create!(value: 1) }
      2.times { post.votes.create!(value: -1) }

      @up_votes = post.votes.where(value: 1).count
      @down_votes = post.votes.where(value: -1).count
    end

    describe '#up_votes' do
      it 'counts the number of votes with value = 1' do
        expect( post.up_votes ).to eq(@up_votes)
      end
    end

    describe '#down_votes' do
      it 'counts the number of votes with value = -1' do
        expect( post.down_votes ).to eq(@down_votes)
      end
    end

    describe '#points' do
      it 'returns the sum of all down and up votes' do
        expect( post.points ).to eq(@up_votes - @down_votes)
      end
    end
  end

  describe '#update_rank' do
    before do
      post.update_rank
    end

    it 'calculates the correct rank' do
      expect(post.rank).to eq (post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
    end

    it 'updates the rank when an up vote is created' do
      old_rank = post.rank
      post.votes.create!(value: 1)
      expect(post.rank).to eq (old_rank + 1)
    end

    it 'updates the rank when a down vote is created' do
      old_rank = post.rank
      post.votes.create!(value: -1)
      expect(post.rank).to eq (old_rank - 1)
    end
  end

  describe '#create_vote' do
    before do
      @new_post = topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
    end

    it 'automatically updates the post with an up vote on create' do
      expect(@new_post.up_votes).to eq(1)
    end

    it 'associates the vote with the current user' do
      expect(@new_post.votes.where(user: user).count).to eq(1)
    end
  end
end
