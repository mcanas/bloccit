module UsersHelper
  def user_has_posts?(user)
    user && user.posts.count > 0
  end

  def user_has_comments?(user)
    user && user.comments.count > 0
  end
end
