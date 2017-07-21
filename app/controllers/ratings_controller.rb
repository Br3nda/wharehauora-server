class RatingsController < ApplicationController
  respond_to :json

  def measurement
    @room = policy_scope(Room).find(params[:room_id])
    authorize @room
    respond_with(room_details)
  end

  private

  def room_details
    room_service = RoomService.new(@room)
    {
      sensors_count: @room.sensors.size,
      room: room_service.room_data,
      readings: room_service.readings,
      ratings: room_service.ratings
    }
  end
end
