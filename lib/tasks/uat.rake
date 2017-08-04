
namespace :uat do
  desc 'Subscribe to incoming sensor messages'
  task testdata: :environment do
    # Home types
    ['Owner occupier', 'Rental', 'Council', 'State housing'].each do |ht|
      HomeType.find_or_create_by! name: ht
    end

    # Room types
    room_types = ['Living space', 'Sleeping/Bedroom', 'Hallway (near bedrooms)', 'Kitchen']
    room_types.each do |rt|
      RoomType.find_or_create_by! name: rt, min_temperature: 18, max_temperature: 28
    end

    admin = User.create! email: 'admin@wharehauora.nz', password: 'password'
    admin.roles << Role.find_by(name: 'janitor')
    # make a room for each room type and home type
    owner = User.create! email: 'uat@wharehauora.nz', password: 'password'
    HomeType.all.each do |home_type|
      home = Home.find_or_create_by!(
        name: "Sample #{home_type.name} whare",
        owner: owner,
        home_type: home_type
      )
      RoomType.all.each do |room_type|
        room = Room.create! home: home, name: "sample #{room_type.name}", room_type: room_type
        sensor = Sensor.create!(node_id: 1000 + room.id, home: home)
        room.sensors << sensor
      end
    end
  end
end
