# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

HomeType.create!(name: "State housing")
HomeType.create!(name: "Council")
HomeType.create!(name: "Rental")
HomeType.create!(name: "Owner occupier")

RoomType.create!(name: "Living space")
RoomType.create!(name: "Sleeping/Bedroom")
RoomType.create!(name: "Kitchen")
