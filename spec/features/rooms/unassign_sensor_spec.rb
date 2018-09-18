# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Room', type: :feature do
  subject { page }

  let(:whanau) do
    user = FactoryBot.create :user
    room.home.users << user
    user
  end

  let(:room) { FactoryBot.create :room_with_sensors }

  shared_examples 'unassign sensor from a room' do
    describe 'unassign sensor from a room' do
      before do
        visit room_path(room.id)
        click_link 'Disconnect from room'
      end

      it { is_expected.not_to have_text 'remove from room' }
    end
  end

  context 'login as whare owner' do
    before { login_as(room.home.owner) }

    include_examples 'unassign sensor from a room'
  end

  context 'login as admin' do
    before { login_as(FactoryBot.create(:admin)) }

    include_examples 'unassign sensor from a room'
  end

  context 'login as whanau' do
    before { login_as(whanau) }

    before { visit room_path(room.id) }

    it { is_expected.not_to have_text 'remove from room' }
  end
end
