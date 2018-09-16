# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:headers) do
    {
      'Accept' => 'application/vnd.api+json',
      'Content-Type' => 'application/vnd.api+json'
    }
  end
  let(:room_type) { FactoryBot.create :room_type, min_temperature: 10, max_temperature: 30 }
  let(:owner)     { room.home.owner                                                        }
  let(:admin)     { FactoryBot.create :admin                                               }
  let(:whanau) do
    whanau = FactoryBot.create :user
    room.home.users << whanau
    whanau
  end

  let(:otheruser) { FactoryBot.create :user }

  # do nothing normally. Contexts below can add readings
  let(:create_readings) {}

  describe '#show' do
    let(:valid_params) { { id: room.id, format: :json } }

    shared_examples 'can see summaries' do
      it { expect(response).to have_http_status(:success) }
    end
    shared_examples 'cannot see summaries' do
      it { expect(response).not_to have_http_status(:success) }
    end

    shared_examples 'returns expected readings' do
      subject { JSON.parse(response.body) }

      let(:readings_response)    { subject['data']['attributes']['readings'] }
      let(:temperature_response) { readings_response['temperature']          }
      let(:humidity_response)    { readings_response['humidity']             }
      let(:dewpoint_response)    { readings_response['dewpoint']             }
      let(:ratings_response)     { subject['data']['attributes']['ratings']  }

      it { expect(subject['data']['attributes']).to include('name' => room.name) }

      describe 'room too hot' do
        let(:create_readings) { FactoryBot.create :temperature_reading, value: 101.1, room: room }

        it { expect(temperature_response).to include('value' => 101.1, 'unit' => '°C') }
        it { expect(ratings_response).to include('good' => false, 'too_hot' => true, 'too_cold' => false) }
      end

      describe 'room too cold' do
        let(:create_readings) { FactoryBot.create :temperature_reading, value: 3.1, room: room }

        it { expect(temperature_response).to include('value' => 3.1, 'unit' => '°C') }
        it { expect(ratings_response).to include('good' => false, 'too_hot' => false, 'too_cold' => true) }
      end

      describe 'room just right' do
        let(:create_readings) { FactoryBot.create :temperature_reading, value: 20.5, room: room }

        it { expect(temperature_response).to include('value' => 20.5, 'unit' => '°C') }
        it { expect(ratings_response).to include('good' => true, 'too_hot' => false, 'too_cold' => false) }
      end
    end

    before do
      create_readings
      sign_in user unless user.nil?
      get :show, params: valid_params
    end

    describe 'When room is in a public home' do
      let(:room) { FactoryBot.create :public_room, room_type: room_type }

      shared_examples 'check permissions' do
        describe 'and user is not logged in ' do
          let(:user) { nil }

          include_examples 'can see summaries'
        end

        describe 'and user is logged in ' do
          describe 'as the whare owner' do
            let(:user) { owner }

            include_examples 'can see summaries'
            include_examples 'returns expected readings'
          end

          describe 'as whanau' do
            let(:user) { whanau }

            include_examples 'can see summaries'
            include_examples 'returns expected readings'
          end

          describe 'as admin' do
            let(:user) { admin }

            include_examples 'can see summaries'
            include_examples 'returns expected readings'
          end

          describe 'as a user from another home' do
            let(:user) { otheruser }

            include_examples 'can see summaries'
            include_examples 'returns expected readings'
          end
        end
      end
    end

    describe 'when room is private' do
      let(:room)      { FactoryBot.create :room, room_type: room_type    }
      let!(:readings) { FactoryBot.create_list :reading, 100, room: room }

      describe 'and user is not logged in ' do
        let(:user) { nil }

        include_examples 'cannot see summaries'
      end

      describe 'and user is logged in ' do
        describe 'as the whare owner' do
          let(:user) { owner }

          include_examples 'can see summaries'
          include_examples 'returns expected readings'
        end

        describe 'as whanau' do
          let(:user) { whanau }

          include_examples 'can see summaries'
          include_examples 'returns expected readings'
        end

        describe 'as admin' do
          let(:user) { admin }

          include_examples 'can see summaries'
          include_examples 'returns expected readings'
        end

        describe 'but user is not allowed to view the room' do
          let(:user) { otheruser }

          include_examples 'cannot see summaries'
        end
      end
    end
  end

  describe '#create' do
    subject { JSON.parse(response.body)['data'] }

    let(:home)  { FactoryBot.create :home, owner: owner }
    let(:owner) { FactoryBot.create :user               }
    let(:body) do
      {
        "type": 'rooms',
        "attributes": {
          "name": 'new room name',
          "home-id": home.id
        }
      }
    end
    before do
      sign_in owner
      request.headers.merge! headers
      post :create, params: { data: body }
    end

    let(:attributes) { subject['attributes'] }

    it { expect(response).to have_http_status(:success) }
    it { expect(attributes['name']).to eq 'new room name' }
    it { expect(attributes['home-id']).to eq home.id }
    it { expect(Room.last.owner.id).to eq owner.id }
  end

  describe '#update' do
    subject { JSON.parse(response.body)['data'] }

    let(:room) { FactoryBot.create :room, room_type: room_type }
    let(:body) do
      {
        "type": 'rooms',
        "id": room.id,
        "attributes": {
          "name": 'new room name'
        }
      }
    end

    before do
      sign_in owner
      request.headers.merge! headers
      patch :update, params: { id: room.to_param, data: body }
    end

    it { expect(Room.find(room.id).name).to eq 'new room name' }
    it { expect(response).to have_http_status(:success) }
  end
end
