# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    skip_policy_scope
    @home_types = HomeType.all.order(:name)
    @room_types = RoomType.all.order(:name)

    time_frame = 1.hour.ago
    @temperature = Reading.readings_by_home_and_room(time_frame).temperature.median(:value)
    @humidity = Reading.readings_by_home_and_room(time_frame).humidity.median(:value)
  end
end
