require 'rails_helper'
include RandomData

RSpec.describe User, type: :model do
  let(:user) { User.create! name: 'Bloccit User', email: 'user@bloccit.com', password: 'password' }

  it { should have_many(:posts) }
  it { should have_many(:comments) }
  it { should have_many(:votes) }
  it { should have_many(:favorites) }

  # tests for name
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(1) }
  it { should allow_value('Bloccit User').for(:name) }
  it { should_not allow_value('bloccit user').for(:name) }

  # tests for email
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:email).is_at_least(3) }
  it { should allow_value('user@bloccit.com').for(:email) }
  it { should_not allow_value('userbloccit.com').for(:email) }

  # tests for password
  it { should validate_presence_of(:password) }
  it { should have_secure_password }
  it { should validate_length_of(:password).is_at_least(6) }

  describe 'attributes' do
    it 'should respond to name' do
      expect(user).to respond_to(:name)
    end

    it 'should respond to email' do
      expect(user).to respond_to(:email)
    end

    it 'should respond to role' do
      expect(user).to respond_to(:role)
    end

    it 'should respond to admin?' do
      expect(user).to respond_to(:admin?)
    end

    it 'should respond to moderator?' do
      expect(user).to respond_to(:moderator?)
    end

    it 'should respond to member?' do
      expect(user).to respond_to(:member?)
    end
  end

  describe 'roles' do
    it 'should be member by default' do
      expect(user.role).to eql('member')
    end

    context 'member user' do
      it 'should return true for #member?' do
        expect(user.member?).to be_truthy
      end

      it 'should return false for #moderator?' do
        expect(user.moderator?).to be_falsey
      end

      it 'should return false for #admin?' do
        expect(user.admin?).to be_falsey
      end
    end

    context 'moderator user' do
      before do
        user.moderator!
      end

      it 'should return false for #member?' do
        expect(user.member?).to be_falsey
      end

      it 'should return true for #moderator?' do
        expect(user.moderator?).to be_truthy
      end

      it 'should return false for #admin?' do
        expect(user.admin?).to be_falsey
      end
    end

    context 'admin user' do
      before do
        user.admin!
      end

      it 'should return false for #member?' do
        expect(user.member?).to be_falsey
      end

      it 'should return false for #moderator?' do
        expect(user.moderator?).to be_falsey
      end

      it 'should return true for #admin?' do
        expect(user.admin?).to be_truthy
      end
    end
  end

  describe 'invalid user' do
    let(:user_with_invalid_name) { User.new name: '', email: 'user@bloccit.com', password: 'password' }
    let(:user_with_invalid_name_format) { User.new name: 'bloccit user', email: 'user@bloccit.com', password: 'password' }
    let(:user_with_invalid_email) { User.new name: 'Bloccit User', email: '', password: 'password' }
    let(:user_with_invalid_email_format) { User.new name: 'Bloccit User', email: 'userbloccit.com', password: 'password' }

    it 'should be an invalid user due to blank name' do
      expect(user_with_invalid_name).to_not be_valid
    end

    it 'should be an invalid user due to incorrectly formatted name' do
      expect(user_with_invalid_name_format).to_not be_valid
    end

    it 'should be an invalid user due to blank email' do
      expect(user_with_invalid_email).to_not be_valid
    end

    it 'should be an invalid user due to incorrectly formatted email address' do
      expect(user_with_invalid_email_format).to_not be_valid
    end
  end

  describe '#favorite_for(post)' do
    before do
      new_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
      @new_post = new_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
    end

    it 'returns `nil` if the user has not favorited the post' do
      expect(user.favorite_for(@new_post)).to be_nil
    end

    it 'returns the appopriate favorite if it exists' do
      favorite = user.favorites.where(post: @new_post).create
      expect(user.favorite_for(@new_post)).to eq(favorite)
    end
  end
end
