require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  shared_examples 'can see measurements' do
    it { expect(response).to have_http_status(:success) }
  end
  shared_examples 'cannot see measurements' do
    it { expect(response).not_to have_http_status(:success) }
  end

  let(:owner) { room.home.owner }
  let(:admin) { FactoryGirl.create :admin }
  let(:whanau) do
    whanau = FactoryGirl.create :user
    home.home_viewers << whanau
    whanau
  end
  let(:otheruser) { FactoryGirl.create :user }

  let(:room) { FactoryGirl.create :room }
  let(:valid_params) { { room_id: room.id } }

  before do
    10.times { FactoryGirl.create :reading, room: room }
    get :measurement, valid_params
  end

  describe 'When room is in a public home' do
    describe 'and user is not logged in ' do
      include_examples 'can see measurements'
    end
    describe 'and user is logged in ' do
      describe 'as the whare owner' do
        before { sign_in owner }
        include_examples 'can see measurements'
      end
      describe 'as whanau' do
        before { sign_in whanau }
        include_examples 'can see measurements'
      end
      describe 'as admin' do
        before { sign_in admin }
        include_examples 'can see measurements'
      end
      describe 'as a user from another home' do
        before { sign_in otheruser }
        include_examples 'can see measurements'
      end
    end
  end

  describe 'when room is private' do
    describe 'and user is not logged in ' do
      include_examples 'cannot see measurements'
    end
    describe 'and user is logged in ' do
      describe 'as the whare owner' do
        before { sign_in owner }
        include_examples 'can see measurements'
      end
      describe 'as whanau' do
        before { sign_in whanau }
        include_examples 'can see measurements'
      end
      describe 'as admin' do
        before { sign_in admin }
        include_examples 'can see measurements'
      end
      describe 'but user is not allowed to view the room' do
        before { sign_in otheruser }
        include_examples 'cannot see measurements'
      end
    end
  end
end
