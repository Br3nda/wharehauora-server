# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit destroy update]
  before_action :set_home, only: %i[index edit update]

  respond_to :html

  def index
    authorize @home
    @rooms = @home.rooms.order(:name).paginate(page: params[:page])
    @unassigned_sensors = @home.sensors.where(room_id: nil)
    respond_with(@rooms)
  end

  def show
    skip_authorization if @room.public?
    @readings = Reading.where(room: @room).order(created_at: :desc).limit(10)
    respond_with(@room)
  end

  def edit
    respond_with(@room)
  end

  def update
    @room.update(room_params)
    redirect_to home_rooms_path(@home)
  end

  def destroy
    if @room.sensors.empty?
      ActiveRecord::Base.transaction do
        Reading.where(room_id: @room.id).delete_all
        @room.destroy
      end
    end
    respond_with @room, location: home_rooms_path(@room.home)
  end

  private

  def set_home
    @home = @room ? @room.home : policy_scope(Home).find(params[:home_id])
    authorize @home
  end

  def set_room
    @room = policy_scope(Room).find(params[:id])
    authorize @room
    @home = @room.home
  end

  def room_params
    params[:room].permit(permitted_room_params)
  end

  def permitted_room_params
    %i[name room_type_id]
  end
end
