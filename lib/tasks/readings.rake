# frozen_string_literal: true

namespace :readings do
  desc 'Subscribe to incoming sensor messages'
  task aggregate: :environment do
    Room.has_readings.limit(10).each do |room|
      %w[temperature humidity].each do |key|
        newest_median = room.readings.where(key: "median_#{key}").order(:created_at).first
        room.readings
            .where(key: key)
            .where('created_at > ?', newest_median.created_at) # reading created after the last aggregation run
            .where('created_at < ?', 2.hours.ago) # and the whole hour is in the past
            .group("date_trunc('hour', created_at)")
            .median(:value).each do |ts, value|
          Reading.create!(key: "median_#{key}", value: value, created_at: ts, room: room)
        end

        newest_median = room.readings.where(key: "median_#{key}").order(:created_at).first

        # delete the readings we have aggregated
        room.readings.where(key: key).where('created_at < ?', newest_median.created_at).delete_all
      end
    end
  end
end
