# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Room', type: :feature do
  let(:whanau) do
    user = FactoryBot.create :user
    room.home.users << user
    user
  end

  subject { page }

  let(:room) { FactoryBot.create :room_with_sensors }

  shared_examples 'unassign sensor from a room' do
    describe 'unassign sensor from a room' do
      before do
        visit room_path(room.id)
        click_link 'remove from room'
      end
      it { is_expected.not_to have_text 'remove from room' }
    end
  end

  context 'login as whare owner' do
    background { login_as(room.home.owner) }
    include_examples 'unassign sensor from a room'
  end

  context 'login as admin' do
    background { login_as(FactoryBot.create(:admin)) }
    include_examples 'unassign sensor from a room'
  end

  context 'login as whanau' do
    background { login_as(whanau) }
    before(:each) { visit room_path(room.id) }
    it { is_expected.not_to have_text 'remove from room' }
  end
end
