require 'rails_helper'

RSpec.feature 'Sensors', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:admin_user) { FactoryGirl.create :admin }
  let(:home_type) { FactoryGirl.create :home_type }
  let(:home) { FactoryGirl.create :home, owner_id: user.id, home_type: home_type, name: 'Taku whare whanau' }

  subject { page }

  shared_examples 'then a 1 new sensor is detected' do
    include_examples 'rooms#index'
    it { is_expected.to have_text 'new sensors detected' }
    it { is_expected.to have_link 'Assign to room' }
    it { is_expected.to have_text sensor.node_id }
  end

  shared_examples 'no sensors detected' do
    include_examples 'rooms#index'
    it { is_expected.not_to have_text 'new sensors detected' }
    it { is_expected.not_to have_link 'Assign to room' }
  end

  shared_examples 'rooms#index' do
    before { visit "/homes/#{home.id}/rooms" }
  end

  shared_examples 'when home has one sensor' do
    let!(:sensor) { FactoryGirl.create :sensor, home: home }
    it { expect(home.sensors.size).to eq(1) }
  end

  shared_examples 'sensor has messages' do
    let!(:sensor) { FactoryGirl.create :sensor, home: home }
    let!(:messages) { FactoryGirl.create :message, 100, sensor: sensor }
  end

  context 'normal user' do
    background { login_as(home.owner) }
    context 'rooms#index' do
      context '1 unassigned sensor' do
        include_examples 'when home has one sensor'
        include_examples 'then a 1 new sensor is detected'
      end

      context 'no sensors' do
        include_examples 'no sensors detected'
      end
    end

    context 'assign sensor' do
      let!(:sensor) { FactoryGirl.create :sensor, home: home }

      context 'to a new room' do
        before do
          visit "/homes/#{home.id}/rooms"
          click_link 'Assign to room'
          fill_in 'sensor_room_name', with: 'room of oarsum'
          click_button 'Save'
        end
        it { is_expected.to have_text 'room of oarsum' }
        it { is_expected.to have_link 'Analyse' }
        include_examples 'no sensors detected'
      end

      context 'home has one room' do
        let!(:existing_room) { FactoryGirl.create :room, name: 'library', home: home }
        before do
          visit "/homes/#{home.id}/rooms"
          click_link 'Assign to room'
          choose "sensor_room_id_#{existing_room.id}"
          click_button 'Save'
        end
        it { is_expected.not_to have_text 'new sensors detected' }
        it { is_expected.to have_text existing_room.name }
        it { is_expected.to have_link 'Analyse' }
      end
    end
  end

  context 'Not signed in' do
  end

  context 'Signed in as an admin users' do
    background { login_as(admin_user) }

    context 'sensors#index' do
      context '1 unassigned sensor' do
        include_examples 'when home has one sensor'
        before { visit "/homes/#{home.id}/sensors" }
        it { is_expected.to have_text sensor.node_id }
      end
    end

    context 'sensors#delete' do
      context '1 unassigned sensor' do
        include_examples 'when home has one sensor'
        include_examples 'sensor has messages'
        before do
          visit "/homes/#{home.id}/sensors"
          click_button 'delete'
        end
        it { is_expected.to have_text 'sensor deleted' }
      end
    end

    context 'rooms#index' do
      context '1 unassigned sensor' do
        include_examples 'when home has one sensor'
        include_examples 'then a 1 new sensor is detected'
      end

      context 'no sensors' do
        include_examples 'no sensors detected'
      end
    end
  end
end
