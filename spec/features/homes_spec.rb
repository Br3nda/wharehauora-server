require 'rails_helper'

RSpec.feature 'Homes', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, owner_id: user.id }
  context 'Normal user' do
    background { login_as(user) }
    scenario 'Views their home' do
      visit "/homes/#{home.id}"
      expect(page).to have_text(home.name)
    end
    scenario 'Views their friend\'s home' do
      other_home = FactoryGirl.create :home
      user.homes << other_home
      visit "/homes/#{other_home.id}"
      expect(page).to have_text(other_home.name)
    end
  end
end
