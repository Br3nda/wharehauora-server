# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    skip_policy_scope
    skip_authorization
    @home_types = HomeType.all.order(:name)
    @room_types = RoomType.all.order(:name)

    @temperature = readings('temperature', time_frame).median(:value)
    @humidity = readings('humidity', time_frame).median(:value)
    @day = Time.zone.today
  end

  def time_frame
    3.hours.ago
  end

  def readings(key, created_after)
    Reading.joins(:room, room: :home)
           .where('home_type_id IS NOT NULL AND room_type_id IS NOT NULL')
           .where('readings.created_at >= ?', created_after)
           .where(key: key)
           .group('home_type_id', 'room_type_id')
  end
end
