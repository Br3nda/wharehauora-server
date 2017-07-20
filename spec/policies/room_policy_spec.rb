require 'rails_helper'

describe RoomPolicy do
  let(:admin) { FactoryGirl.create :admin }
  let(:owner) { room.home.owner }
  let(:whanau) do
    u = FactoryGirl.create :user
    room.home.users << u
    u
  end
  let(:other_user) { FactoryGirl.create :user }

  subject { described_class.new(user, room) }

  shared_examples 'can see the room' do
    it { is_expected.to permit_action(:show) }
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

  context 'public room' do
    let(:room) { FactoryGirl.create :public_room }

    context 'a visitor' do
      let(:user) { nil }
      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end

    context 'home owner' do
      let(:user) { owner }
      include_examples 'can see the room'
      include_examples 'can edit the room'
      include_examples 'can delete the room'
    end

    context 'whanau' do
      let(:user) { whanau }
      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end

    context 'admin' do
      let(:user) { admin }
      include_examples 'can see the room'
      include_examples 'can edit the room'
      include_examples 'can delete the room'
    end

    context 'another user, not whanau' do
      let(:user) { other_user }
      include_examples 'can see the room'
      include_examples 'forbidden to edit the room'
    end
  end
end
