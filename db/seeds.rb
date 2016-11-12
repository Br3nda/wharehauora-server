# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

state_house = HomeType.create!(name: "State housing")
HomeType.create!(name: "Council")
HomeType.create!(name: "Rental")
HomeType.create!(name: "Owner occupier")

living_room = RoomType.create!(name: "Living space")
bedroom = RoomType.create!(name: "Sleeping/Bedroom")

home = Home.create!(name: "Example home 1", home_type: state_house)
Sensor.create!(name: "living room", home: home, room_type_id: living_room.id)
Sensor.create!(name: "parent's room", home: home, room_type_id: bedroom.id)
Sensor.create!(name: "eldest child's room", home: home, room_type_id: bedroom.id)
Sensor.create!(name: "youngest child's room", home: home, room_type_id: bedroom.id)
