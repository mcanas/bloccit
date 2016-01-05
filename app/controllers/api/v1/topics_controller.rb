class Api::V1::TopicsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    topics = Topic.all
    render json: topics.to_json, status: 200
  end

  def show
    topic = Topic.find(params[:id])
    render json: topic.to_json(:include => :posts), status: 200
  end

  def update
    topic = Topic.find(params[:id])

    if topic.update_attributes(topic_params)
      render json: topic.to_json, status: 200
    else
      render json: { error: 'Topic update failed', status: 400 }, status: 400
    end
  end

  def create
    topic = Topic.new(topic_params)

    if topic.valid?
      topic.save!
      render json: topic.to_json, status: 201
    else
      render json: { error: 'Topic is invalid', status: 400 }, status: 400
    end
  end

  def destroy
    topic = Topic.find(params[:id])

    if topic.destroy
      render json: { message: 'Topic destroyed', status: 200 }, status: 200
    else
      render json: { error: 'Topic destoy failed', status: 400 }, status: 400
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :public)
  end
end
