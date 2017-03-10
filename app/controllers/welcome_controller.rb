# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    skip_policy_scope
    skip_authorization
    @home_types = HomeType.all.order(:name)
    @room_types = RoomType.all.order(:name)

    @temperature = metrics.temperature.median(:value)
    @humidity = metrics.humidity.median(:value)
    @sensor_count = Sensor.count
  end

  def time_frame
    3.hours.ago
  end

  def metrics
    Metric.metrics_by_home_and_room(time_frame)
  end
end
