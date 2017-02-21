# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_my_homes
  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end

  def not_found
    render file: 'public/404', status: :not_found, layout: false
  end

  def set_my_homes
    return unless current_user
    @my_homes = policy_scope(Home).where(owner_id: current_user.id) + current_user.homes
  end
end
