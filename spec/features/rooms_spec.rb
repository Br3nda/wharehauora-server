require 'rails_helper'

RSpec.feature 'Rooms', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:janitor) { FactoryGirl.create :role, name: 'janitor' }
  let(:admin_user) { FactoryGirl.create :user, roles: [janitor] }
  let(:home_type) { FactoryGirl.create :home_type }
  let!(:home) { FactoryGirl.create :home, owner_id: user.id, home_type: home_type }
  let(:room) { FactoryGirl.create :room, name: 'bedroom', home: home }
  context 'Normal user' do
    background { login_as(user) }
    scenario 'home has no rooms' do
      visit "/homes/#{home.id}/rooms"
      expect(page).to have_text(home.name)
      expect(page).to have_text('Home has no rooms')
    end

    scenario 'home has 1 room' do
      room = FactoryGirl.create :room, home: home
      visit "/homes/#{home.id}/rooms"
      expect(page).to have_text(home.name)
      expect(page).to have_text(room.name)
    end

    scenario 'home has 100 rooms' do
      100.times { FactoryGirl.create :room, home: home }
      visit "/homes/#{home.id}/rooms"
      expect(page).to have_text(home.rooms.order(:name).first.name)
    end

    # pending 'Views their friend\'s home' do
    # other_home = FactoryGirl.create :home
    # user.viewable_homes << other_home
    # visit "/homes/#{other_home.id}"
    # expect(page).to have_text(other_home.name)
    # end
  end

  context 'Admin users' do
    background { login_as(admin_user) }
    scenario 'Views list of homes' do
      visit '/homes'
      expect(page).to have_text(home.name)
    end
  end
end
