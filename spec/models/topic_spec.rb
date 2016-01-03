require 'rails_helper'
include RandomData

RSpec.describe Topic, type: :model do
  let(:topic) { create(:topic) }

  it { should have_many(:posts) }
  it { should have_many(:labelings) }
  it { should have_many(:labels).through(:labelings) }

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

  describe 'scopes' do
    before do
      @public_topic = create(:topic)
      @private_topic = create(:topic, public: false)
    end

    describe 'visible_to(user)' do
      it 'returns all topics if the user is present' do
        user = create(:user)
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end

      it 'returns only public topics if user is nil' do
        expect(Topic.visible_to(nil)).to eq([@public_topic])
      end
    end

    describe 'publicly_viewable' do
      it 'returns all public topics' do
        public_topics = Topic.publicly_viewable;
        expect(public_topics).to include(@public_topic)
        expect(public_topics).not_to include(@private_topic)
      end
    end

    describe 'privately_viewable' do
      it 'returns all private topics' do
        private_topics = Topic.privately_viewable;
        expect(private_topics).to include(@private_topic)
        expect(private_topics).not_to include(@public_topic)
      end
    end
  end
end
