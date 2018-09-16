# frozen_string_literal: true

require 'rails_helper'

describe RoomPolicy do
  subject { described_class.new(user, room) }

  let(:admin) { FactoryBot.create :admin }
  let(:owner) { room.home.owner          }
  let(:whanau) do
    u = FactoryBot.create :user
    room.home.users << u
    u
  end
  let(:other_user) { FactoryBot.create :user }

  shared_examples 'can see the room' do
    it { is_expected.to permit_action(:show) }
  end

  shared_examples 'forbidden to see the room' do
    it { is_expected.to forbid_action(:show) }
  end

  shared_examples 'can edit the room' do
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
  end

  shared_examples 'forbidden to edit the room' do
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
    include_examples 'forbidden to delete the room'
  end

  shared_examples 'forbidden to delete the room' do
    it { is_expected.to forbid_action(:destroy) }
  end

  shared_examples 'can delete the room' do
    it { is_expected.to permit_action(:destroy) }
  end

  shared_examples 'home owner can see and edit room' do
    context 'home owner' do
      let(:user) { owner }

      include_examples 'can see the room'
      include_examples 'can edit the room'
      include_examples 'can delete the room'
    end
  end

  shared_examples 'admin can do everything' do
    context 'admin' do
      let(:user) { admin }

      include_examples 'can see the room'
      include_examples 'can edit the room'
      include_examples 'can delete the room'
    end
  end

  shared_examples 'whanau can view but not edit' do
    context 'whanau' do
      let(:user) { whanau }

      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end
  end

  context 'private room' do
    let(:room) { FactoryBot.create :room }

    context 'a visitor' do
      let(:user) { nil }

      include_examples 'forbidden to see the room'
      include_examples 'forbidden to edit the room'
    end

    context 'another user, not whanau' do
      let(:user) { other_user }

      include_examples 'forbidden to see the room'
      include_examples 'forbidden to edit the room'
    end

    include_examples 'home owner can see and edit room'
    include_examples 'whanau can view but not edit'
    include_examples 'admin can do everything'
  end

  context 'public room' do
    let(:room) { FactoryBot.create :public_room }

    context 'a visitor' do
      let(:user) { nil }

      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end

    context 'another user, not whanau' do
      let(:user) { other_user }

      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end

    include_examples 'home owner can see and edit room'
    include_examples 'whanau can view but not edit'
    include_examples 'admin can do everything'
  end
end
