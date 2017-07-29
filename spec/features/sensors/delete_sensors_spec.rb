require 'rails_helper'

RSpec.feature 'delete sensors', type: :feature do
  let(:home) do
    FactoryGirl.create(:home_with_sensors, sensors_count: 15)
  end
  let(:whanau) do
    user = FactoryGirl.create :user
    home.users << user
    user
  end

  subject { page }

  shared_examples 'lists sensors' do
    describe 'shows list of sensors in home' do
      before { visit "/homes/#{home.id}/sensors" }
      it { is_expected.to have_text home.name }
      it { is_expected.to have_text home.sensors.first.node_id }
      it { is_expected.to have_text home.sensors.second.node_id }
      it { is_expected.to have_text home.sensors.last.node_id }
    end
  end

  shared_examples 'delete sensor' do
    let!(:sensor) { FactoryGirl.create :sensor, home: home }
    describe 'deletes a sensor in home' do
      before do
        visit "/homes/#{home.id}/sensors"
        click_link "/sensors/#{sensor.id}"
      end
      it { is_expected.not_to have_text sensor.node_id }
    end
  end

  context 'signed in as a normal user' do
    background { login_as(home.owner) }
    include_examples 'lists sensors'
  end

  context 'signed in as whanau' do
    background { login_as(whanau) }
    include_examples 'lists sensors'
  end

  context 'signed in as admin' do
    background { login_as(FactoryGirl.create(:admin)) }
    include_examples 'lists sensors'
    include_examples 'delete sensor'
  end
end
