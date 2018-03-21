require 'rails_helper'

RSpec.feature 'Whare Types', type: :feature do
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create :user }
  let!(:existing) { FactoryBot.create(:home_type, name: 'Cake whare') }

  context 'not signed in' do
    scenario 'requests whare type admin page' do
      visit '/admin/home_types'
      expect(page).not_to have_text('whare types')
    end
  end

  context 'Normal user' do
    background { login_as(user) }
    scenario 'requests whare type admin page' do
      visit '/admin/home_types'
      expect(page).not_to have_text('whare types')
    end
  end

  context 'Logged in as admin' do
    subject { page }
    background { login_as(admin_user) }
    scenario 'Admin sees home_types list' do
      visit '/admin/home_types'
      expect(page).to have_text('Cake whare')
    end

    scenario 'User creates a new home_type' do
      visit '/admin/home_types/new'
      fill_in 'home_type_name', with: 'Marae'
      click_button
      expect(page).to have_text('Marae')
    end

    scenario 'deletes a home_type' do
      visit admin_home_types_path
      is_expected.to have_text existing.name
      click_link 'delete'
      is_expected.not_to have_text existing.name
    end
  end
end
