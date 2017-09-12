# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    skip_policy_scope
    skip_authorization
    @public_homes = public_homes

    # @temperature = readings('temperature', time_frame).median(:value)
    # @humidity = readings('humidity', time_frame).median(:value)
    # @day = Time.zone.today
  end

  private

  def public_homes
    Home.where(is_public: true)
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
