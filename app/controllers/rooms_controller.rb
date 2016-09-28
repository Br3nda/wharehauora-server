# frozen_string_literal: true
class RoomsController < WebController
  before_action :authenticate_user!

  def index
    @rooms = policy_scope(Room)
  end

  def show
    @room = Room.find(params[:id])
    authorize @room
  end

  def new
    @home = Home.find(params[:home_id])
    authorize @home
    @room = Room.new(home_id: @home.id)
  end

  def create
    home = Home.find(params[:home_id])
    authorize home
    room = Room.new(room_params.merge(home_id: home.id))
    authorize room
    room.save!
    redirect_to home
  end

  def edit
    @room = Room.find(params[:id])
    authorize @room
  end

  def update
    room = Room.find(params[:id])
    room.update(room_params)
    authorize room
    room.save!
    redirect_to room.home
  end

  private

  def room_params
    params[:room].permit(permitted_room_params)
  end

  def permitted_room_params
    %i(
      name
      home_id
    )
  end
end
