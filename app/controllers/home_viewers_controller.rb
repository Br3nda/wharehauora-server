class HomeViewersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @viewers = policy_scope(HomeViewer).where(home_id: params[:home_id]).page(params[:page])
  end

  def new
    authorize :user
    @viewer = HomeViewer.new
  end

  def create
    @home = Home.find!(id: params[:home_id])
    authorize @home
    @user = User.find_by!(email: params[:viewer][:email])
    @viewer = HomeViewer.new(home_id: @home.id, user_id: @user.id).save!
    redirect_to home_path(@home)
  end

  private

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
