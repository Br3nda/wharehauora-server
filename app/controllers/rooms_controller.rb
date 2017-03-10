class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :destroy, :update]
  before_action :set_home, only: [:index, :edit, :update]

  respond_to :html

  def index
    authorize @home
    @rooms = policy_scope(@home.rooms)
    respond_with(@rooms)
  end

  def show
    authorize @room
    @readings = Reading.where(room: @room)
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 50)

    @temperature = temperature_data
    @humidity = humidity_data
  end

  def edit
    authorize @room
  end

  def update
    authorize @room
    @room.update(room_params)
    redirect_to home_rooms_path(@home)
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
  end

  def set_room
    @room = policy_scope(Room).find(params[:id])
  end

  def room_params
    params[:room].permit(permitted_room_params)
  end

  def permitted_room_params
    %i(
      name
      room_type_id
    )
  end

  def temperature_data
    time_series Reading.temperature
  end

  def humidity_data
    time_series Reading.humidity
  end

  def time_series(query)
    policy_scope(query).where(room_id: @room.id)
                       .where(['readings.created_at >= ?', 1.day.ago])
                       .pluck("date_trunc('minute', readings.created_at)", :value)
  end
end
