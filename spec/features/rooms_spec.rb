require 'rails_helper'

RSpec.feature 'Rooms', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:janitor) { FactoryGirl.create :role, name: 'janitor' }
  let(:admin_user) { FactoryGirl.create :user, roles: [janitor] }

  let(:home_type) { FactoryGirl.create :home_type }
  let!(:home) { FactoryGirl.create :home, owner_id: user.id, home_type: home_type }

  context 'Normal user' do
    background { login_as(user) }
    context 'home has no rooms' do
      before { visit "/homes/#{home.id}/rooms" }
      it { expect(page).to have_text(home.name) }
      it { expect(page).to have_text('Home has no rooms') }
    end

    context 'home has 1 room' do
      let!(:room) { FactoryGirl.create :room, name: 'bedroom', home: home, room_type: room_type }
      let(:room_type) { FactoryGirl.create :room_type, min_temperature: 20.0, max_temperature: 40 }
      describe '#index' do
        describe 'no readings' do
          before { visit "/homes/#{home.id}/rooms" }
          it { expect(page).to have_text(room.name) }
          it { expect(page).to have_text('??.?') }
          it { expect(page).to have_text('No current humidity') }
          it { expect(page).to have_text('No current temperature') }
        end

        describe 'one temperature reading' do
          before do
            FactoryGirl.create :reading, key: 'temperature', value: 44.4, room: room
            visit "/homes/#{home.id}/rooms"
          end
          it { expect(page).to have_text('44.4C') }
        end

        describe 'too cold' do
          before do
            FactoryGirl.create :reading, key: 'temperature', value: 15.1, room: room
            visit "/homes/#{home.id}/rooms"
          end
          it { expect(page).to have_text('15.1C') }
          it { expect(page).to have_text('Too cold') }
          it { expect(page).to have_text('No current humidity') }
        end

        describe 'too hot' do
          before do
            FactoryGirl.create :reading, key: 'temperature', value: 45.2, room: room
            visit "/homes/#{home.id}/rooms"
          end
          it { expect(page).to have_text('45.2C') }
          it { expect(page).to have_text('Too hot') }
        end
      end
    end
    context 'home has 100 rooms' do
      before do
        100.times { FactoryGirl.create :room, home: home }
        visit "/homes/#{home.id}/rooms"
      end
      it { expect(page).to have_text(home.rooms.order(:name).first.name) }
    end

    context 'Admin users' do
      background { login_as(admin_user) }
      context 'Views list of homes' do
        before { visit '/homes' }
        it { expect(page).to have_text(home.name) }
      end
    end
  end
end
