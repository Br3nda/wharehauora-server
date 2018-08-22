# frozen_string_literal: true

class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    authorize :user
    @users = policy_scope User.all.order(:email).page(params[:page])
  end

  def new
    authorize :user
    @user = User.new
    authorize @user
  end

  def edit
    @roles = current_user.roles
  end

  def update
    @user.update!(user_params)
    @user.confirm
    redirect_to admin_users_path
  rescue StandardError
    render :edit, @user
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    u = params.require(:user).permit(:name, :email, role_ids: [])
    u[:role_ids] = [] if u[:role_ids].blank?
    u
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
