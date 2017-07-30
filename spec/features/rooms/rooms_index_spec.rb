require 'rails_helper'

RSpec.feature 'Rooms', type: :feature do
  let!(:home) { FactoryGirl.create :home }

  subject { page }

  context 'Whare owner' do
    background { login_as(home.owner) }

    context 'home has no rooms' do
      before { visit home_rooms_path(home.id) }
      it { is_expected.to have_text(home.name) }
      it { is_expected.to have_text('This whare has no monitored rooms.') }
    end

    context 'home has 1 room' do
      let(:room_type) { FactoryGirl.create :room_type, min_temperature: 20.0, max_temperature: 40 }
      describe '#index' do
        shared_examples 'show home and room' do
          it { is_expected.to have_text(home.name) }
          it { is_expected.to have_text(room.name) }
          it { is_expected.to have_text(room.room_type.name) }
        end

        describe 'no readings' do
          let(:room) { FactoryGirl.create :room, home: home, room_type: room_type }
          before { visit home_rooms_path(room.home.id) }
          include_examples 'show home and room'
        end

        describe 'one temperature reading' do
          let(:room) { FactoryGirl.create :room, temperature: 44.4, home: home, room_type: room_type }
          before { visit home_rooms_path(room.home.id) }
          include_examples 'show home and room'
        end

        describe 'too cold' do
          let(:room) { FactoryGirl.create :room, temperature: 15.1, home: home, room_type: room_type }
          before { visit home_rooms_path(home.id) }
          include_examples 'show home and room'
        end

        describe 'too hot' do
          let(:room) { FactoryGirl.create :room, temperature: 45.2, home: home, room_type: room_type }
          before { visit home_rooms_path(home.id) }
          include_examples 'show home and room'
        end
      end
    end

    context 'home has 100 rooms' do
      before do
        100.times { FactoryGirl.create :room, home: home }
        visit home_rooms_path(home.id)
      end
      it { is_expected.to have_text(home.rooms.order(:name).first.name) }
    end

    context 'Views list of homes' do
      let!(:otherhome) { FactoryGirl.create :home, name: "another person's home" }
      before { visit '/homes' }
      it { is_expected.to have_text(home.name) }
      it { is_expected.to have_text(home.home_type.name) }
      it { is_expected.not_to have_text(otherhome.name) }
    end
  end

  # context 'Admin users' do
  #   background { login_as(admin_user) }
  #   context 'Views list of homes' do
  #     before { visit '/homes' }
  #     it { is_expected.to have_text(home.name) }
  #   end
  # end
end
