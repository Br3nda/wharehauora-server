# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :feature do
  let(:user)       { FactoryBot.create :user }
  let(:janitor)    { FactoryBot.create :role, name: 'janitor' }
  let(:admin_user) { FactoryBot.create :user, roles: [janitor] }
  let(:home_type)  { FactoryBot.create :home_type }
  let!(:home)      { FactoryBot.create :home, owner_id: user.id, home_type: home_type }

  context 'Normal user' do
    before { login_as(user) }

    it 'Views their home' do
      visit "/homes/#{home.id}"
      expect(page).to have_text(home.name)
    end

    it 'Views their friend\'s home' do
      other_home = FactoryBot.create :home
      user.viewable_homes << other_home
      visit "/homes/#{other_home.id}"
      expect(page).to have_text(other_home.name)
    end
  end

  context 'Admin users' do
    before { login_as(admin_user) }

    it 'Views list of homes' do
      visit '/homes'
      expect(page).to have_text(home.name)
    end
  end
end
