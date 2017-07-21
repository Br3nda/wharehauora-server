require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  shared_examples 'can see measurements' do
    it { expect(response).to have_http_status(:success) }
  end
  shared_examples 'cannot see measurements' do
    it { expect(response).not_to have_http_status(:success) }
  end

  shared_examples 'response has expected keys' do
    subject { JSON.parse response.body }
    it { is_expected.to include('sensors_count') }
    it { is_expected.to include('room') }
    it { is_expected.to include('readings') }
  end

  shared_examples 'returns expected readings' do
    subject { JSON.parse response.body }

    let(:readings_response) { subject['readings'] }
    let(:temperature_response) { readings_response['temperature'] }
    let(:humidity_response) { readings_response['humidity'] }
    let(:dewpoint_response) { readings_response['dewpoint'] }
    let(:ratings_response) { subject['ratings'] }

    it { expect(subject['room']).to include('id' => room.id, 'name' => room.name) }
    describe 'room too hot' do
      let(:create_readings) { FactoryGirl.create :temperature_reading, value: 101.1, room: room }
      it { expect(temperature_response).to include('value' => '101.1', 'unit' => '°C') }
      it { expect(ratings_response).to include('good' => false, 'too_hot' => true, 'too_cold' => false) }
    end

    describe 'room too cold' do
      let(:create_readings) { FactoryGirl.create :temperature_reading, value: 3.1, room: room }
      it { expect(temperature_response).to include('value' => '3.1', 'unit' => '°C') }
      it { expect(ratings_response).to include('good' => false, 'too_hot' => false, 'too_cold' => true) }
    end

    describe 'room just right' do
      let(:create_readings) { FactoryGirl.create :temperature_reading, value: 20.5, room: room }
      it { expect(temperature_response).to include('value' => '20.5', 'unit' => '°C') }
      it { expect(ratings_response).to include('good' => true, 'too_hot' => false, 'too_cold' => false) }
    end
  end # returns expected readings


  let(:room_type) { FactoryGirl.create :room_type, min_temperature: 10, max_temperature: 30 }
  let(:owner) { room.home.owner }
  let(:admin) { FactoryGirl.create :admin }
  let(:whanau) do
    whanau = FactoryGirl.create :user
    room.home.users << whanau
    whanau
  end
  let(:otheruser) { FactoryGirl.create :user }

  let(:valid_params) { { room_id: room.id, format: :json } }

  # do nothing normally. Contexts below can add readings
  let(:create_readings) {}

  before do
    create_readings
    sign_in user unless user.nil?
    get :measurement, valid_params
  end

  describe 'When room is in a public home' do
    let(:room) { FactoryGirl.create :public_room, room_type: room_type }

    shared_examples 'check permissions' do
      describe 'and user is not logged in ' do
        let(:user) { nil }
        include_examples 'can see measurements'
      end

      describe 'and user is logged in ' do
        describe 'as the whare owner' do
          let(:user) { owner }
          include_examples 'can see measurements'
          include_examples 'returns expected readings'
        end
        describe 'as whanau' do
          let(:user) { whanau }
          include_examples 'can see measurements'
          include_examples 'returns expected readings'
        end
        describe 'as admin' do
          let(:user) { admin }
          include_examples 'can see measurements'
          include_examples 'returns expected readings'
        end
        describe 'as a user from another home' do
          let(:user) { otheruser }
          include_examples 'can see measurements'
          include_examples 'returns expected readings'
        end
      end
    end
  end

  describe 'when room is private' do
    let(:room) { FactoryGirl.create :room, room_type: room_type }
    let!(:readings) { FactoryGirl.create_list :reading, 100, room: room }
    describe 'and user is not logged in ' do
      let(:user) { nil }
      include_examples 'cannot see measurements'
    end
    describe 'and user is logged in ' do
      describe 'as the whare owner' do
        let(:user) { owner }
        include_examples 'can see measurements'
        include_examples 'returns expected readings'
      end
      describe 'as whanau' do
        let(:user) { whanau }
        include_examples 'can see measurements'
        include_examples 'returns expected readings'
      end
      describe 'as admin' do
        let(:user) { admin }
        include_examples 'can see measurements'
        include_examples 'returns expected readings'
      end
      describe 'but user is not allowed to view the room' do
        let(:user) { otheruser }
        include_examples 'cannot see measurements'
      end
    end
  end
end
