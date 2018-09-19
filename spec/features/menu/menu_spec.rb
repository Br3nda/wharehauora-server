# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :feature do
  subject { page }

  let(:user)       { FactoryBot.create :user                                               }
  let(:janitor)    { FactoryBot.create :janitor                                            }
  let(:admin_user) { FactoryBot.create :user, roles: [janitor]                             }
  let(:home_type)  { FactoryBot.create :home_type                                          }
  let!(:home)      { FactoryBot.create :home, owner_id: user.id, home_type: home_type      }
  let!(:room)      { FactoryBot.create :room, home: home                                   }


  context 'Not logged in' do
    before { visit '/' }

    it { is_expected.to have_link('Sign in') }
    it { is_expected.to have_link('Sign up') }
    it { is_expected.not_to have_link('Logout') }
  end

  context 'Normal user' do
    before do
      login_as(user)
      visit '/'
    end

    it { is_expected.to have_text(home.name) }
    it { is_expected.to have_link(room.name, href: room_path(room)) }
    it { is_expected.to have_link('Whānau') }
    it { is_expected.to have_link('Change password') }
    it { is_expected.to have_link('Logout') }
  end

  context 'Admin users' do
    before do
      login_as(admin_user)
      visit '/'
    end

    it { is_expected.to have_link('Whare') }
    it { is_expected.to have_link('Whare Types') }
    it { is_expected.to have_link('Room Types') }
    it { is_expected.to have_link('Users') }
    it { is_expected.to have_link('MQTT') }
    it { is_expected.to have_link('Messages') }
    it { is_expected.to have_link('Change password') }
    it { is_expected.to have_link('Logout') }
  end
end
