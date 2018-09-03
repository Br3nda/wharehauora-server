# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Widget management', type: :feature do
  let(:admin_role) { FactoryBot.create(:role, name: 'janitor')        }
  let(:admin_user) { FactoryBot.create(:user, roles: [admin_role])    }
  let(:user)       { FactoryBot.create :user                          }
  let!(:existing)  { FactoryBot.create(:room_type, name: 'Cake room') }

  context 'not signed in' do
    it 'requests room type admin page' do
      visit '/admin/room_types'
      expect(page).not_to have_text('Room types')
    end
  end

  context 'Normal user' do
    before { login_as(user) }

    it 'requests room type admin page' do
      visit '/admin/room_types'
      expect(page).not_to have_text('Room types')
    end
  end

  context 'Logged in as admin' do
    before { login_as(admin_user) }

    it 'Admin sees room_types list' do
      visit '/admin/room_types'
      expect(page).to have_text('Cake room')
    end

    it 'User creates a new room_type' do
      visit '/admin/room_types/new'
      fill_in 'room type name', with: 'Pool room'
      click_button

      # expect(page).to have_text('Room type was successfully created.')
      expect(page).to have_text('Pool room')
    end
  end
end
