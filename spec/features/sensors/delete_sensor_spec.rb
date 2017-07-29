require 'rails_helper'

RSpec.feature 'admin lists sensors', type: :feature do
  let(:home) do
    FactoryGirl.create(:home)
  end
  let(:whanau) do
    user = FactoryGirl.create :user
    home.users << user
    user
  end

  subject { page }

  shared_examples 'delete sensor' do
    describe 'deletes a sensor in home' do
      before do
        visit "/homes/#{sensor.home.id}/sensors"
        # click_link "/sensors/#{sensor.id}" # delete method
        click_link 'delete'
      end
      it { is_expected.not_to have_text sensor.node_id }
    end
  end

  # context 'signed in as a normal user' do
  #   background { login_as(home.owner) }
  #   include_examples 'lists sensors'
  # end

  # context 'signed in as whanau' do
  #   background { login_as(whanau) }
  #   include_examples 'lists sensors'
  # end

  context 'signed in as admin' do
    background { login_as(FactoryGirl.create(:admin)) }
    context 'unassigned sensor' do
      let(:sensor) { FactoryGirl.create :sensor, home: home, room: nil }
      include_examples 'delete sensor'
    end
    context 'assigned sensor' do
      let(:room) { FactoryGirl.create :room, home: home }
      let(:sensor) { FactoryGirl.create :sensor, home: home, room: room }
      include_examples 'delete sensor'
    end
    context 'sensor with messages' do
      let(:sensor) { FactoryGirl.create :sensor_with_messages, home: home }
      include_examples 'delete sensor'
    end
  end
end
