class RatingsController < ApplicationController
  respond_to :json

  def measurement
    @room = Room.find(params[:room_id])
    @key = params[:key]

    authorize @room
    respond_with(room_details)
  end

  private

  def room_details
    {
      sensors_count: @room.sensors.size,
      room: room_data,
      readings: readings,
      ratings: ratings
    }
  end

  def ratings
    {
      good: @room.good?,
      min_temperature: @room.room_type&.min_temperature,
      max_temperature: @room.room_type&.max_temperature,
      too_cold: @room.too_cold?,
      too_hot: @room.too_hot?
    }
  end

  def readings
    readings = {}
    %w[temperature humidity dewpoint].each do |key|
      readings[key] = reading_data key
    end
    readings
  end

  def reading_data(key)
    @reading = @room.most_recent_reading(key)
    if @reading
      {
        # key: @reading.key,
        value: format('%.1f', @reading.value),
        unit: @reading.unit,
        timestamp: @reading.created_at,
        current: @reading.current?
      }
    end
  rescue
    {}
  end

  def room_data
    {
      id: @room.id,
      name: @room.name,
      room_type: { name: @room.room_type&.name }
    }
  end
end
