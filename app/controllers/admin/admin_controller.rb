class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    authenticate_user!
    fail Pundit::NotAuthorizedError unless current_user.janitor?
  end
end
