# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'analyse room', type: :feature do
  subject { page }

  let(:whanau) do
    user = FactoryBot.create :user
    room.home.users << user
    user
  end

  shared_examples 'show room analysis' do
    shared_examples 'can see room details' do
      it "shows room's name" do
        is_expected.to have_text(room.name)
      end
    end

    describe 'visit room analysis page' do
      before { visit home_room_path(room.home.id, room.id) }

      context 'room with no readings' do
        let(:room) { FactoryBot.create :room }

        include_examples 'can see room details'
      end

      context 'room with temperature' do
        let(:room) { FactoryBot.create :room, temperature: 10.0 }

        it { is_expected.to have_text '10.0°C' }
        include_examples 'can see room details'
      end

      context 'room with humidity' do
        let(:room) { FactoryBot.create :room, humidity: 75.4 }

        it { is_expected.to have_text '75.4%' }
        include_examples 'can see room details'
      end

      context 'room with dewpoint' do
        let(:room) { FactoryBot.create :room, dewpoint: 7.6 }

        it { is_expected.to have_text '7.6°C' }
        include_examples 'can see room details'
      end
    end
  end

  context 'login as whare owner' do
    before { login_as(room.home.owner) }

    include_examples 'show room analysis'
  end

  context 'login as whanau' do
    before { login_as(whanau) }

    include_examples 'show room analysis'
  end

  context 'login as admin' do
    before { login_as(FactoryBot.create(:admin)) }

    include_examples 'show room analysis'
  end
end
