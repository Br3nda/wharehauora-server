class Admin::CleanerController < Admin::AdminController
  def index
    authorize :cleaner
    skip_policy_scope
    @rooms_no_readings = Room.with_no_readings.with_no_sensors.size
    @sensors_no_messages = Sensor.with_no_messages.size
  end

  def rooms
    authorize :cleaner
    ActiveRecord::Base.transaction do
      Room.with_no_readings.with_no_sensors.each(&:destroy)
    end
    redirect_to admin_cleaner_path
  end

  def sensors
    authorize :cleaner
    ActiveRecord::Base.transaction do
      Sensor.with_no_messages.each(&:destroy)
    end
    redirect_to admin_cleaner_path
  end
end
