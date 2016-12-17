# frozen_string_literal: true
class WelcomeController < ApplicationController
  def index
    @public_homes = Home.where(is_public: true).order(:name)
    @home_types = HomeType.all.order(:name)
    @room_types = RoomType.all.order(:name)

    set_medians
    skip_policy_scope
  end

  private

  def set_medians
    @medians = {}
    @home_types.each do |home_type|
      @medians[home_type.id] = {}
      @room_types.each do |room_type|
        @medians[home_type.id][room_type.id] = median(home_type, room_type)
      end
    end
  end

  def median(home_type, room_type)
    Reading.joins(:sensor, sensor: :home)
           .where('homes.home_type_id': home_type.id, 'sensors.room_type_id': room_type.id)
           .temperature.median(:value)
  end
end
