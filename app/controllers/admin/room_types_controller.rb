class Admin::RoomTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room_type, only: [:show, :edit, :update, :destroy]

  def index
    @home_types = policy_scope(RoomType)
  end
  def edit; end
  def update; end
  def new; end
  def create; end
  def destroy
    @home_type.destroy!
    redirect_to admin_room_types_path
  end

  private

  def set_room_type
    @home_type = RoomType.find(params[:id])
    authorize @home_type
  end
end
