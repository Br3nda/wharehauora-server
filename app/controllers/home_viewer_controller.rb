class HomeViewerController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize :user
    @vieiwers = Viewer.page(params[:page])
  end

  def new
    authorize :user
    @vieiwer = Viewer.new
  end

  def create
    @viewer = User.find_by!(email: params[:vieiwer][:email])
    @home = Home.find!(id: params[:home_id])
    authorize @home
    @viewer = Viewer.new(home_id: @home.id, user_id: @viewer.id).save!
    redirect_to home_path(@home)
  end

  private

  def vieiwer_params
    params[:vieiwer].permit(permitted_params)
  end

  def permitted_params
    %i(
      id
      email
      home_id
    )
  end
end
