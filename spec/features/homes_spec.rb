# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :feature do
  let(:user)       { FactoryBot.create :user                                    }
  let(:admin_user) { FactoryBot.create :admin                                   }
  let(:home_type)  { FactoryBot.create :home_type                               }
  let!(:home)      { FactoryBot.create :home, owner: user, home_type: home_type }

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
    before 'create a home' do
      login_as(admin_user)
      visit new_home_path
      expect(page).to have_text 'New whare to monitor'

      fill_in :home_name, with: 'cool new home'
      fill_in 'home[gateway_mac_address]', with: 'ABCD99'
      fill_in 'owner[email]', with: 'bob@bob.com'

      click_button
    end

    it { expect(page).to have_http_status 200 }
    it { expect(page).to have_text 'Home was successfully created' }
    it { expect(page).to have_text 'Activate sensors in your home, and they will appear here.' }
    it { expect(page).to have_link 'Provision MQTT' }

    it { expect(Home.last.name).to eq 'cool new home' }
    it { expect(Home.last.gateway_mac_address).to eq 'ABCD99' }
    it { expect(Home.last.owner.email).to eq 'bob@bob.com' }
    it { expect(User.last.email).to eq 'bob@bob.com' }
  end
end
