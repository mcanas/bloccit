class PostsController < ApplicationController
  def index
    i = 0
    @posts = censor_posts(Post.all)
  end

  def show
  end

  def new
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
