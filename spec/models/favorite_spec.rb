require 'rails_helper'
include RandomData

RSpec.describe Favorite, type: :model do
  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:favorite) { Favorite.create!(user: user, post: post) }

  it { should belong_to :post }
  it { should belong_to :user }
end
