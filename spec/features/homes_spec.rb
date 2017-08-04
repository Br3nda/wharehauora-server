require 'rails_helper'

RSpec.feature 'Homes', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:janitor) { FactoryGirl.create :role, name: 'janitor' }
  let(:admin_user) { FactoryGirl.create :user, roles: [janitor] }
  let(:home_type) { FactoryGirl.create :home_type }
  let!(:home) { FactoryGirl.create :home, owner_id: user.id, home_type: home_type }
  context 'Normal user' do
    background { login_as(user) }
    scenario 'Views their home' do
      visit "/homes/#{home.id}"
      expect(page).to have_text(home.name)
    end

    scenario 'Views their friend\'s home' do
      other_home = FactoryGirl.create :home
      user.viewable_homes << other_home
      visit "/homes/#{other_home.id}"
      expect(page).to have_text(other_home.name)
    end
  end

  context 'Admin users' do
    background { login_as(admin_user) }
    scenario 'Views list of homes' do
      visit '/homes'
      expect(page).to have_text(home.name)
    end
  end
end
