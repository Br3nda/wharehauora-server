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
if %w[development test staging].include? Rails.env
  ActiveRecord::Base.transaction do
    num_mock_readings = 100
    roomtypes = ['Living space', 'Sleeping/Bedroom']
    roomtypes.each do |rt|
      RoomType.create!(name: rt) unless RoomType.find_by(name: rt)
    end

    state_house = HomeType.find_by(name: 'State housing')

    living_room = RoomType.find_by(name: 'Living space')
    bedroom = RoomType.find_by(name: 'Sleeping/Bedroom')

    unless User.find_by(email: 'rabid@example.com')
      User.create!(email: 'rabid@example.com',
                   password: 'password', password_confirmation: 'password')
    end

    user = User.find_by(email: 'rabid@example.com')

    unless Home.find_by(name: 'Example home 1')
      Home.create!(name: 'Example home 1',
                   home_type: state_house, owner_id: user.id)
    end

    home = Home.find_by!(name: 'Example home 1')

    sensors = [{ node_id: 100, home: home, room: Room.create(name: 'living room', home: home, room_type_id: living_room.id) },
               { node_id: 101, home: home, room: Room.create(name: "parent's room", home: home, room_type_id: bedroom.id) },
               { node_id: 102, home: home, room: Room.create(name: "eldest child's room", home: home, room_type_id: bedroom.id) },
               { node_id: 103, home: home, room: Room.create(name: "youngest child's room", home: home, room_type_id: bedroom.id) }]

    modifier = 1
    sensors.each do |s|
      modifier += 0.125
      next if Sensor.find_by(s)

      sensor = Sensor.create!(s)
      x = 1

      while x <= num_mock_readings
        Message.create!(sensor: sensor,
                        payload: Math.sin(x) * 10 * modifier,
                        message_type: MySensors::SetReq::V_TEMP,
                        child_sensor_id: 1,
                        node_id: sensor.node_id,
                        ack: 0,
                        sub_type: 1,
                        created_at: x.hour.ago)
        Message.create!(sensor: sensor,
                        payload: Math.tan(x) * 10 * modifier,
                        message_type: MySensors::SetReq::V_HUM,
                        child_sensor_id: 0,
                        ack: 0,
                        sub_type: 1,
                        node_id: sensor.node_id,
                        created_at: x.hour.ago)
        x += 1
      end
    end
  end
end
