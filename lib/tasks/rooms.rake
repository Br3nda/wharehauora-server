namespace :rooms do
  desc 'Records room ratings in the database'
  task rate: :environment do
    begin
      RoomRatings.new.run
    rescue Exception => e # rubocop:disable Lint/RescueException
      Raygun.track_exception(e) if Rails.env.production?
      raise
    end
  end
end

class RoomRatings
  def run
    Room.joins(:home).joins(:owner).each do |room|
      Reading.create! key: 'rating', value: room.calculate_rating, room: room if room.enough_info_to_perform_rating?
    end
  end
end
