# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin sensors in a home', type: :feature do
  subject { page }

  let(:home) do
    FactoryBot.create(:home_with_sensors, sensors_count: 15)
  end

  let(:whanau) do
    user = FactoryBot.create :user
    home.users << user
    user
  end

  shared_examples 'lists sensors' do
    describe 'shows list of sensors in home' do
      before { visit "/homes/#{home.id}/sensors" }

      it { is_expected.to have_text home.name }
      it { is_expected.to have_text home.sensors.first.node_id }
      it { is_expected.to have_text home.sensors.second.node_id }
      it { is_expected.to have_text home.sensors.last.node_id }
    end
  end

  context 'signed in as a normal user' do
    before { login_as(home.owner) }

    include_examples 'lists sensors'
  end

  context 'signed in as whanau' do
    before { login_as(whanau) }

    include_examples 'lists sensors'
  end

  context 'signed in as admin' do
    before { login_as(FactoryBot.create(:admin)) }

    include_examples 'lists sensors'
  end
end
