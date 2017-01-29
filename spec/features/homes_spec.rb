require 'rails_helper'

RSpec.feature 'Homes', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, owner_id: user.id }

  context 'not signed in' do
    scenario 'requests user admin page' do
      visit "/homes/#{home.id}"
      expect(page).not_to have_text(home.name)
    end
  end

  context 'Normal user' do
    background { login_as(user) }
    scenario 'requests user admin page' do
      visit "/homes/#{home.id}"
      expect(page).to have_text(home.name)
    end
  end

  # context 'Logged in as admin' do
  #   background { login_as(admin_user) }
  #   scenario 'Admin sees users list' do
  #     visit "/homes/#{home.id}"
  #     expect(page).to have_text(home.name)
  #   end

  # scenario 'User creates a new widget' do
  #   visit "/homes/#{home.id}"new'
  #   expect(page).to have_text('Invite new user')
  #   fill_in 'Name', with: 'Pool room'
  #   click_button 'Invite'

  #   # expect(page).to have_text('Room type was successfully created.')
  #   expect(page).to have_text('Pool room')
  # end
  # end
end
