# frozen_string_literal: true

# require 'rails_helper'

# RSpec.feature 'Front page', type: :feature do
#   let(:user) { FactoryBot.create :user }
#   let!(:public_home) { FactoryBot.create :home, home_type: home_type, is_public: true }
#   let!(:private_home) { FactoryBot.create :home, home_type: home_type, is_public: false }
#   let!(:public_room) { FactoryBot.create :room, home: public_home, room_type: room_type }
#   let!(:private_room) do
#     FactoryBot.create :room, home: private_home, room_type: room_type,
#                              name: 'this is a private room'
#   end
#   let(:home_type) { FactoryBot.create :home_type }
#   let(:room_type) { FactoryBot.create :room_type, min_temperature: 18, max_temperature: 30 }

#   before do
#     100.times { FactoryBot.create :reading, room: public_room }
#     100.times { FactoryBot.create :reading, room: private_room }
#   end

#   shared_examples 'displays only public data' do
#     before { visit '/' }
#     pending { expect(page).to have_text('Live demo data') }
#     pending 'displays public room name' do
#       expect(page).to have_text(public_room.name)
#     end
#     pending 'does not show private room' do
#       expect(page).not_to have_text(private_room.name)
#     end
#     pending 'offers analyse button' do
#       expect(page).to have_link('Analyse')
#     end
#     pending 'offers analyse button' do
#       expect(page).to have_link('Analyse')
#     end
#   end

#   shared_examples 'can analyse public home' do
#     before { visit '/' }
#     pending 'allows viewing room' do
#       click_link 'Analyse'
#       expect(page).to have_text(public_room.name)
#     end
#   end

#   context 'user is not signed in' do
#     describe 'views front page' do
#       include_examples 'displays only public data'
#       include_examples 'can analyse public home'
#     end
#   end

#   context 'user is signed in as normal user' do
#     background { login_as(user) }
#     describe 'views front page' do
#       include_examples 'displays only public data'
#       include_examples 'can analyse public home'
#     end
#   end

#   context 'user is owner of public home' do
#     background { login_as(public_home.owner) }
#     describe 'views front page' do
#       include_examples 'displays only public data'
#       include_examples 'can analyse public home'
#     end
#   end
# end
