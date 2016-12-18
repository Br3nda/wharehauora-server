# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    @public_homes = Home.where(is_public: true).order(:name)
    @home_types = HomeType.all.order(:name)
    @room_types = RoomType.all.order(:name)

    set_temperature
    set_humidity
    skip_policy_scope
  end

  private

  def set_temperature
    @temperature = {}
    @home_types.each do |home_type|
      @temperature[home_type.id] = {}
      @room_types.each do |room_type|
        @temperature[home_type.id][room_type.id] = median_temperature(home_type, room_type)
      end
    end
  end

  def set_humidity
    @humidity = {}
    @home_types.each do |home_type|
      @humidity[home_type.id] = {}
      @room_types.each do |room_type|
        @humidity[home_type.id][room_type.id] = median_humidity(home_type, room_type)
      end
    end
  end

  def median_temperature(home_type, room_type)
    Reading.joins(:sensor, sensor: :home)
           .where('readings.created_at >= ?', 1.hour.ago)
           .where('homes.home_type_id': home_type.id, 'sensors.room_type_id': room_type.id)
           .temperature.median(:value)
  end

  def median_humidity(home_type, room_type)
    Reading.joins(:sensor, sensor: :home)
           .where('readings.created_at >= ?', 1.hour.ago)
           .where('homes.home_type_id': home_type.id, 'sensors.room_type_id': room_type.id)
           .humidity.median(:value)
  end
end
