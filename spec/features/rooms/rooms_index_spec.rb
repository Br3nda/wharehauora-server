require 'rails_helper'

RSpec.feature 'Rooms', type: :feature do
  let!(:home) { FactoryGirl.create :home }
  let(:whanau) do
    user = FactoryGirl.create :user
    home.users << user
    user
  end

  subject { page }

  shared_examples 'shows room list' do
    context 'home has no rooms' do
      before(:each) { visit home_rooms_path(home.id) }
      it { is_expected.to have_text(home.name) }
      it { is_expected.to have_text('This whare has no monitored rooms.') }
    end

    context 'home has 100 rooms' do
      before(:each) { visit home_rooms_path(home.id) }
      before do
        FactoryGirl.create_list :room, 100, home: home
        visit home_rooms_path(home.id)
      end
      it { is_expected.to have_text(home.rooms.order(:name).first.name) }
    end

    context 'home with 1 room' do
      before(:each) { visit home_rooms_path(room.home.id) }

      let(:room_type) do
        FactoryGirl.create :room_type, min_temperature: 20.0, max_temperature: 40
      end

      describe ' visit #index' do
        shared_examples 'show home and room' do
          it { is_expected.to have_text(home.name, maximum: 1) }
          it { is_expected.to have_text(room.name, maximum: 1) }
          it { is_expected.to have_text(room.room_type.name) }
        end

        describe 'room has no readings' do
          let(:room) { FactoryGirl.create :room, home: home, room_type: room_type }

          include_examples 'show home and room'
          it { expect(room.readings.size).to eq 0 }
        end

        describe 'room has one temperature reading' do
          let(:room) { FactoryGirl.create :room, temperature: 44.4, home: home, room_type: room_type }
          before { visit home_rooms_path(room.home.id) }
          include_examples 'show home and room'
        end

        describe 'room is too cold' do
          let(:room) { FactoryGirl.create :room, temperature: 15.1, home: home, room_type: room_type }
          include_examples 'show home and room'
        end

        describe 'room is too hot' do
          let(:room) { FactoryGirl.create :room, temperature: 45.2, home: home, room_type: room_type }
          include_examples 'show home and room'
        end
      end
    end
  end

  shared_examples 'Test as all user types' do
    context 'Whare owner' do
      background { login_as(home.owner) }
      include_examples 'shows room list'
    end

    context 'Whare owner' do
      background { login_as(whanau) }
      include_examples 'shows room list'
    end

    context 'Admin users' do
      background { login_as(FactoryGirl.create(:admin)) }
      include_examples 'shows room list'
    end

    context 'Not Logged in' do
      before(:each) { visit home_rooms_path(home.id) }
      describe 'Cannot see private home' do
        it { is_expected.not_to have_text(home.name) }
        it { is_expected.not_to have_text('This whare has no monitored rooms.') }
      end
      pending 'Can see public home'
    end
  end

  context 'No other whanau' do
    include_examples 'Test as all user types'
  end
  context 'Homes with lots of Whanau' do
    before { FactoryGirl.create_list(:home_viewer, 7, home: home) }
    it { expect(home.users.size).to eq(7) }
    include_examples 'Test as all user types'
  end
end
