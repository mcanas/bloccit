require 'rails_helper'
include RandomData

RSpec.describe Label, type: :model do
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
  let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
  let(:label) { Label.create!(name: 'Label') }
  let(:label2) { Label.create!(name: 'Label2') }

  it { should belong_to :labelable }
  it { should have_many :labelings }
  it { should have_many :topics }
  it { should have_many :posts }

  describe 'labelable' do
    it 'allows the same label to be associated with a different topic and post' do
      topic.labels << label
      post.labels << label

      topic_label = topic.labels[0]
      post_label = post.labels[0]

      expect(topic_label).to eql(post_label)
    end
  end

  describe '.update_labels' do
    it 'takes a comma delimited string and returns an array of Labels' do
      labels = "#{label.name}, #{label2.name}"
      labels_as_a = [label, label2]

      expect(Label.update_labels(labels)).to eq(labels_as_a)
    end
  end
end
