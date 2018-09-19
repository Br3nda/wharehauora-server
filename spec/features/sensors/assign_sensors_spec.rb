# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assign sensors', type: :feature do
  subject { page }

  let(:home) { FactoryBot.create :home, name: 'Toku whare whanau' }

  shared_context 'home has one unassigned sensor' do
    let!(:sensor) { FactoryBot.create :unassigned_sensor, home: home }
  end

  shared_examples 'new sensors detected and assignable' do
    describe 'sensor is displayed' do
      it { is_expected.to have_text 'New sensors found' }
      it { is_expected.to have_link 'Assign to room' }
      it { is_expected.to have_text sensor.node_id }
    end
  end

  shared_examples 'can assign a sensor to a new room' do
    before do
      visit "/homes/#{home.id}/rooms"
      click_link 'Assign to room'
      fill_in 'sensor_room_name', with: 'room of oarsum'
      click_button 'Save'
    end

    it { is_expected.to have_text 'room of oarsum' }
    it { is_expected.not_to have_text 'new sensors detected' }
    it { is_expected.to have_link 'Analyse' }
  end

  shared_examples 'can see sensors' do
    describe 'can see sensors' do
      context 'with 1 unassigned sensor in home' do
        before { visit "/homes/#{sensor.home_id}/rooms" }

        include_examples 'home has one unassigned sensor'
        it { expect(home.sensors.size).to eq 1 }
        include_examples 'new sensors detected and assignable'
      end

      context 'with no sensors in home' do
        before { visit "/homes/#{home.id}/rooms" }

        describe 'no sensors detected' do
          it { is_expected.not_to have_text 'new sensors detected' }
          it { is_expected.not_to have_link 'Assign to room' }
        end
      end
    end
  end

  shared_examples 'can assign to new room' do
    include_examples 'home has one unassigned sensor'
    describe 'can assign to a new room' do
      before do
        visit "/homes/#{home.id}/rooms"
        click_link 'Assign to room'
        fill_in 'sensor_room_name', with: 'room of oarsum'
        click_button 'Save'
      end

      describe 'no sensors displayed' do
        it { is_expected.not_to have_text 'new sensors detected' }
        it { is_expected.to have_text 'room of oarsum' }
        it { is_expected.to have_link 'Analyse' }
      end
    end
  end

  shared_examples 'can assign to existing room' do
    include_examples 'home has one unassigned sensor'
    describe 'can assign to existing room' do
      let!(:existing_room) { FactoryBot.create :room, name: 'library', home: home, sensors: [] }

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

  context 'signed in as a normal user' do
    before { login_as(home.owner) }

    include_examples 'can see sensors'
    describe 'can assign sensors' do
      include_examples 'can assign to new room'
      include_examples 'can assign to existing room'
    end
  end

  context 'signed in as whanau' do
    let(:whanau) do
      user = FactoryBot.create :user
      home.users << user
      user
    end

    before { login_as(whanau) }

    pending 'can see sensors'
    pending 'cannot assign sensors'
  end

  context 'signed in as admin' do
    before { login_as(FactoryBot.create(:admin)) }

    include_examples 'can see sensors'
    describe 'can assign sensors' do
      include_examples 'can assign to new room'
      include_examples 'can assign to existing room'
    end
  end
end
