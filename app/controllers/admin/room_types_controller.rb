# frozen_string_literal: true

class Admin::RoomTypesController < Admin::AdminController
  respond_to :html
  before_action :set_room_type, only: %i[show edit update destroy]

  def index
    authorize :room_type
    @room_types = policy_scope(RoomType.all).order(:name)
    respond_with :admin, @room_types
  end

  def edit; end

  def update
    @room_type.update(room_type_params)
    respond_with(:admin, @room_type, location: admin_room_types_path)
  end

  def new
    authorize :room_type
    @room_type = RoomType.new
  end

  def create
    authorize :room_type
    @room_type = RoomType.create(room_type_params)
    respond_with(:admin, @room_type, location: admin_room_types_path)
  end

  def destroy
    ActiveRecord::Base.transaction do
      Room.where(room_type: @room_type).update_all(room_type_id: nil)
      @room_type.destroy
    end
    respond_with(:admin, @room_type, location: admin_room_types_path)
  end

  private

  def set_room_type
    @room_type = RoomType.find(params[:id])
    authorize @room_type
  end

  def room_type_params
    params[:room_type].permit(:name, :min_temperature, :max_temperature)
  end
end
