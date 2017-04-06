require 'rails_helper'

RSpec.feature 'Widget management', type: :feature do
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let(:user) { FactoryGirl.create :user }
  let!(:existing) { FactoryGirl.create(:room_type, name: 'Cake room') }

  context 'not signed in' do
    scenario 'requests room type admin page' do
      visit '/admin/room_types'
      expect(page).not_to have_text('Add')
    end
  end

  context 'Normal user' do
    background { login_as(user) }
    scenario 'requests room type admin page' do
      visit '/admin/room_types'
      expect(page).not_to have_text('Add')
    end
  end

  context 'Logged in as admin' do
    background { login_as(admin_user) }
    scenario 'Admin sees room_types list' do
      visit '/admin/room_types'
      expect(page).to have_text('Cake room')
    end

    scenario 'User creates a new widget' do
      visit '/admin/room_types/new'
      expect(page).to have_text('Add')
      fill_in 'Name', with: 'Pool room'
      click_button 'Create'

      # expect(page).to have_text('Room type was successfully created.')
      expect(page).to have_text('Pool room')
    end
  end
end
