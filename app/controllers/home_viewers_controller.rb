class HomeViewersController < ApplicationController
  before_action :authenticate_user!

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
    @user = User.find_or_create_by(email: params[:home_viewer][:user])
    @viewer = HomeViewer.find_or_create_by(home_id: @home.id, user_id: @user.id).save! if @user
    redirect_to home_home_viewers_path(@home)
  end

  def destroy
    @home = Home.find(params[:home_id])
    authorize @home, :edit?
    @user = User.find(params[:id])
    viewer = HomeViewer.find_by(home_id: @home.id, user_id: @user.id)
    viewer.destroy
  ensure
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
