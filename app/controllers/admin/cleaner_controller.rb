class Admin::CleanerController < ApplicationController
  def index
    authorize :cleaner
    skip_policy_scope
    @rooms_no_readings = Room.without_readings.without_sensors.size
    @sensors_no_messages = Sensor.without_messages.size
  end

  def rooms
    authorize :cleaner
    ActiveRecord::Base.transaction do
      Room.without_readings.without_sensors.each(&:destroy)
    end
    redirect_to admin_cleaner_path
  end

  def sensors
    authorize :cleaner
    ActiveRecord::Base.transaction do
      Sensor.without_messages.each(&:destroy)
    end
    redirect_to admin_cleaner_path
  end
end
