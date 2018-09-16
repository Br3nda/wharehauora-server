# frozen_string_literal: true

class Api::V1::ReadingsController < ApplicationController
  respond_to :json

  def index
    @room = Room.find_by(id: params[:room_id])
    authorize @room, :show?
    @readings = {}
    %w[temperature humidity dewpoint].each do |key|
      @readings[key] = readings(params[:week], key)
    end
    render json: { room: @room, readings: @readings }
  end

  def readings(week_start, key)
    policy_scope(Reading).where(key: key, room: @room).by_week(week_start)
                         .group("date_trunc('hour', readings.created_at)")
                         .median(:value)
  end
end
