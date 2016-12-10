class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.page(params[:page])
  end

  def new
    @user = User.new
    authorize @user
  end

  def edit
    @roles = current_user.roles
  end

  def update
    @user.update!(user_params)
    @user.save!
    redirect_to users_path
  rescue
    render :edit, @user
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
