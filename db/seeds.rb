# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ActiveRecord::Base.transaction do
  hometypes = ['Owner occupier', 'Rental', 'Council', 'State housing']
  roles = [{ name: 'janitor', friendly_name: 'System janitor' }]

  hometypes.each do |ht|
    HomeType.create!(name: ht) unless HomeType.find_by(name: ht)
  end

  roles.each do |r|
    Role.create!(name: r[:name], friendly_name: r[:friendly_name]) unless Role.find_by(name: r[:name])
  end
end

# rubocop:disable BlockLength
# rubocop:disable LineLength
if %w(development test staging).include? Rails.env
  ActiveRecord::Base.transaction do
    num_mock_readings = 100
    roomtypes = ['Living space', 'Sleeping/Bedroom']
    roomtypes.each do |rt|
      RoomType.create!(name: rt) unless RoomType.find_by(name: rt)
    end

    state_house = HomeType.find_by(name: 'State housing')

    living_room = RoomType.find_by(name: 'Living space')
    bedroom = RoomType.find_by(name: 'Sleeping/Bedroom')

    User.create!(id: 1, email: 'rabid@example.com', password: 'password', password_confirmation: 'password') unless User.find_by(email: 'rabid@example.com')

    user = User.find_by(email: 'rabid@example.com')

    Home.create!(name: 'Example home 1', home_type: state_house, owner_id: user.id) unless Home.find_by(name: 'Example home 1')
    home = Home.find_by(name: 'Example home 1')

    sensors = [{ id: 1, name: 'My new sensor', room_name: 'living room', home: home, room_type_id: living_room.id },
               { id: 2, name: 'Old loaned sensor', room_name: "parent's room", home: home, room_type_id: bedroom.id },
               { id: 3, name: 'Jimmy Sensor the Third', room_name: "eldest child's room", home: home, room_type_id: bedroom.id },
               { id: 4, name: 'XR56Z', room_name: "youngest child's room", home: home, room_type_id: bedroom.id }]

    sensors.each do |s|
      next if Sensor.find_by(s)

      Sensor.create!(s)
      x = 1

      while x <= num_mock_readings
        Reading.create!(sensor_id: s[:id], key: 'foo', value: Math.sin(x) * 10, sub_type: MySensors::SetReq::V_TEMP, created_at: x.hour.ago)
        Reading.create!(sensor_id: s[:id], key: 'foo', value: Math.tan(x) * 10, sub_type: MySensors::SetReq::V_HUM, created_at: x.hour.ago)
        x += 1
      end
    end
  end
end
