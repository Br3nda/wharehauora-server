class Admin::RoomTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room_type, only: [:show, :edit, :update, :destroy]

  def index
    authorize :room_type
    @room_types = policy_scope(RoomType)
  end

  def edit; end

  def update
    @room_type.update!(room_type_params)
    redirect_to admin_room_types_path
  end

  def new
    authorize :room_type
    @room_type = RoomType.new
  end

  def create
    authorize :room_type
    RoomType.create(room_type_params)
    redirect_to admin_room_types_path
  end

  def destroy
    @room_type.destroy
    redirect_to admin_room_types_path
  end

  private

  def set_room_type
    @room_type = RoomType.find(params[:id])
    authorize @room_type
  end

  def room_type_params
    params[:room_type].permit(:name)
  end
end
