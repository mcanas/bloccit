class TopicsController < ApplicationController
  before_action :require_sign_in, except: [:index, :show]
  before_action :authorize_moderator, only: [:edit, :update]
  before_action :authorize_admin, except: [:index, :edit, :update, :show]

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      @topic.labels = Label.update_labels(params[:topic][:labels])
      redirect_to @topic, notice: 'Topic was saved successfully.'
    else
      flash[:error] = 'Error creating topic. Please try again.'
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.assign_attributes(topic_params)

    if @topic.save
      @topic.labels = Label.update_labels(params[:topic][:labels])
      flash[:notice] = 'Topic was updated.'
      redirect_to @topic
    else
      flash[:error] = 'Error saving topic. Please try again.'
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])

    if @topic.destroy
      flash[:notice] = "\"#{@topic.name}\" was deleted successfully."
      redirect_to action: :index
    else
      flash[:error] = 'There was an error deleting the topic.'
      render :show
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :public)
  end

  def authorize_moderator
    unless current_user.moderator? || current_user.admin?
      flash[:error] = 'You must be a moderator or admin to do that.'
      redirect_to topics_path
    end
  end

  def authorize_admin
    unless current_user.admin?
      flash[:error] = 'You must be an admin to do that.'
      redirect_to topics_path
    end
  end
end
