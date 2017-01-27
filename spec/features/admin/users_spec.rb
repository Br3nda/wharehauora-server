require 'rails_helper'

RSpec.feature 'Widget management', type: :feature do
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let!(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let!(:user) { FactoryGirl.create :user }

  context 'not signed in' do
    scenario 'requests user admin page' do
      visit '/admin/users'
      expect(page).not_to have_text('Invite new user')
    end
  end

  context 'Normal user' do
    background { login_as(user) }
    scenario 'requests user admin page' do
      visit '/admin/users'
      expect(page).not_to have_text('Invite new user')
    end
  end

  context 'Logged in as admin' do
    background { login_as(admin_user) }
    scenario 'Admin sees users list' do
      visit '/admin/users'
      expect(page).to have_text(admin_user.email)
      expect(page).to have_text(user.email)
    end

    # scenario 'User creates a new widget' do
    #   visit '/admin/users/new'
    #   expect(page).to have_text('Invite new user')
    #   fill_in 'Name', with: 'Pool room'
    #   click_button 'Invite'

    #   # expect(page).to have_text('Room type was successfully created.')
    #   expect(page).to have_text('Pool room')
    # end
  end
end
