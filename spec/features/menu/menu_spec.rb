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

    it { is_expected.to have_button('Login') }
    it { is_expected.to have_link('Sign up') }
    it { is_expected.not_to have_link('Logout') }
  end

  shared_examples 'password and logout links' do
    it { is_expected.to have_link('Change password') }
    it { is_expected.to have_link('Logout') }
  end

  context 'Normal user' do
    before { login_as(user) }

    describe 'root path' do
      before { visit '/' }

      it { is_expected.to have_link(home.name) }
      include_examples 'password and logout links'
    end

    describe 'selected a home' do
      before { visit home_path(home) }

      it { is_expected.to have_text(home.name) }
      it { is_expected.to have_link(room.name, href: room_path(room)) }
      it { is_expected.to have_link('Whānau') }
      include_examples 'password and logout links'
    end
  end

  context 'Admin users' do
    before do
      login_as(admin_user)
      visit '/'
    end

    it { is_expected.to have_link(home.name) }

    it { is_expected.to have_link('Whare') }
    it { is_expected.to have_link('Whare Types') }
    it { is_expected.to have_link('Room Types') }
    it { is_expected.to have_link('Users') }
    it { is_expected.to have_link('MQTT') }
    it { is_expected.to have_link('Messages') }
    include_examples 'password and logout links'
  end
end
