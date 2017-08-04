class Api::RoomsController < ApplicationController
  respond_to :json

  def show
    @room = policy_scope(Room).find(params[:id])
    authorize @room
    respond_with(room_summary)
  end

  private

  def room_summary
    RoomService.new(@room).summary
  end
end
