# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  force_ssl if Rails.env.production?
  before_action :set_my_homes
  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    respond_to do |format|
      format.html { redirect_to(request.referer || root_path) }
      format.json { render json: { error: flash[:error] }, status: :forbidden }
    end
  end

  def not_found
    render file: 'public/404', status: :not_found, layout: false
  end

  def set_my_homes
    return unless current_user

    @my_homes = current_user.homes
  end
end
