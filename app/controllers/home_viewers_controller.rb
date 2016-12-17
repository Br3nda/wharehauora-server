class HomeViewersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @home = Home.find(params[:home_id])
    authorize @home, :edit?
    @viewers = policy_scope(HomeViewer).where(home_id: params[:home_id]).page(params[:page])
    @new_viewer = HomeViewer.new
  end

  def new
    @home = Home.find(params[:home_id])
    authorize @home, :edit?
    @new_viewer = HomeViewer.new
  end

  def create
    @home = Home.find(params[:home_id])
    authorize @home, :edit?
    @user = User.find_by(email: params[:home_viewer][:user])
    @viewer = HomeViewer.new(home_id: @home.id, user_id: @user.id).save! if @user
    redirect_to home_home_viewers_path(@home)
  end

  private

  def invite_user; end

  def viewer_params
    params[:viewer].permit(permitted_params)
  end

  def permitted_params
    %i(
      id
      email
      home_id
    )
  end
end
