class RoomSummaryController < ApplicationController
  respond_to :json

  def summary
    @room = policy_scope(Room).find(params[:room_id])
    authorize @room
    respond_with(room_summary)
  end

  private

  def room_summary
    room_service = RoomService.new(@room)
    {
      sensors_count: @room.sensors.size,
      room: room_service.room_data,
      readings: room_service.readings,
      ratings: room_service.ratings
    }
  end
end
