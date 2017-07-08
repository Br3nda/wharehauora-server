class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show edit destroy update]
  before_action :set_home, only: %i[index edit update]

  respond_to :html

  def index
    authorize @home
    @rooms = policy_scope(Room)
             .where(home_id: @home.id)
             .includes(:home, :sensors, :room_type)
             .order(:name)
             .paginate(page: params[:page])
    respond_with(@rooms)
  end

  def show
    parse_dates
    @home = @room.home
    @keys = %w[temperature humidity]
    @dampest = @room.dampest.limit(1).first
    @coldest = @room.coldest.limit(1).first
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
    redirect_to home_rooms_path(@room.home)
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
  end

  def set_room
    @room = policy_scope(Room).includes(:home).find(params[:id])
    authorize @room
  end

  def room_params
    params[:room].permit(permitted_room_params)
  end

  def permitted_room_params
    %i[name room_type_id]
  end

  def parse_dates
    @day = params[:day]
    @day = Date.yesterday if @day.blank?
  end
end
