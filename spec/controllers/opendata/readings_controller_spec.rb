# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Opendata::ReadingsController, type: :controller do
  let(:user)         { FactoryBot.create :user              }
  let(:home)         { FactoryBot.create :home, owner: user }
  let(:valid_params) { { key: 'temperature', day: day }     }
  let(:day)          { '2017-01-01'                         }

  context 'Not signed in' do
    describe 'GET index' do
      before { get :index, params: valid_params }

      it { expect(response).to have_http_status(:success) }
    end
  end

  context 'Signed in as home owner' do
    before { sign_in user }

    describe 'GET index' do
      describe 'no readings yet' do
        it { expect(response).to have_http_status(:success) }
      end

      describe 'has readings' do
        before do
          @readings = []
          @room_types = []
          5.times do
            room_type = FactoryBot.create :room_type
            @room_types << room_type
            room = FactoryBot.create :room, home: home, room_type: room_type
            6.times do
              @readings << FactoryBot.create(:reading, room: room, key: 'temperature', value: 10, created_at: day)
              @readings << FactoryBot.create(:reading, room: room, key: 'humidity', value: 10, created_at: day)
            end
          end
          get :index, params: valid_params
        end

        it { expect(response).to have_http_status(:success) }
        it 'finds readings, organised by room types' do
          expected_value = [[Time.zone.parse(day), 10.0]]

          expect(assigns(:data).count).to eq(5)
          @room_types.each do |rt|
            expect(assigns(:data)).to include('name' => rt.name, 'data' => expected_value)
          end
        end
      end
    end
  end
end
