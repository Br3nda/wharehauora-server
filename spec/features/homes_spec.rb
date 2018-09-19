# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :feature do
  let(:user)       { FactoryBot.create :user                                          }
  let(:admin_user) { FactoryBot.create :admin                                         }
  let(:home_type)  { FactoryBot.create :home_type                                     }
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
    subject do
      visit new_home_path
      fill_in :home_name, with: 'cool new home'
      fill_in 'home[gateway_mac_address]', with: 'ABCD99'
      fill_in 'owner[email]', with: 'bob@bob.com'
      click_button('Create')
    end

    before { login_as(admin_user) }

    it { expect { subject }.to change(Home, :count).by(1) }
    it { expect { subject }.to change(User, :count).by(1) }
    describe 'new data matches' do
      before { subject }

      it { expect(Home.last.name).to eq 'cool new home' }
      it { expect(Home.last.owner.email).to eq 'bob@bob.com' }
      it { expect(User.last.email).to eq 'bob@bob.com' }
    end
  end
end
