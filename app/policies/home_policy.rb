class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  def initialize(user, post)
    @user = user
    @post = post
  end

  # def update?
  #   user.admin? or not post.published?
  # end
end
