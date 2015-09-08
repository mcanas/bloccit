class PostsController < ApplicationController
  def index
    i = 0
    #@posts = censor_posts(Post.all)
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]

    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to @post
    else
      flash[:error] = "There was an error saving the post. Please try again"
      render :new
    end
  end

  def edit
  end

  def censor_posts(posts)
    if posts
      i = 0
      posts.each do |post|
        i += 1
        post.title = 'CENSORED' if i % 5 == 0
      end
    end
    posts
  end
end
