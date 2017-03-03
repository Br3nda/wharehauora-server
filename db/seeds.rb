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

  if %w(development test staging).include? Rails.env
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

    Sensor.create!(name: 'living room', home: home, room_type_id: living_room.id)
    Sensor.create!(name: "parent's room", home: home, room_type_id: bedroom.id)
    Sensor.create!(name: "eldest child's room", home: home, room_type_id: bedroom.id)
    Sensor.create!(name: "youngest child's room", home: home, room_type_id: bedroom.id)
  end
end
