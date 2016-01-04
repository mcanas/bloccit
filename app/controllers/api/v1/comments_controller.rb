class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    if params[:post_id]
      post = Post.find(params[:post_id])
      comments = post.comments
    else
      comments = Comment.all
    end

    render json: comments, status: 200
  end

  def show
    comment = Comment.find(params[:id])
    render json: comment, status: 200
  end
end
