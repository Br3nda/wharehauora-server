# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  let(:user)         { home.owner                                       }
  let(:home)         { FactoryBot.create :home                          }
  let(:room)         { FactoryBot.create :room, home: home              }
  let(:valid_params) { { room_id: room.id, key: 'temperature' }         }

  context 'Not signed in' do
    describe 'GET index' do
      before { get :index, params: valid_params }

      it { expect(response).not_to have_http_status(:success) }
    end
  end

  context 'Signed in as home owner' do
    before { sign_in user }

    describe 'GET index' do
      before { get :index, params: valid_params }

      describe 'no readings yet' do
        it { expect(response).to have_http_status(:success) }
      end

      describe 'has readings' do
        before do
          5.times do
            room = FactoryBot.create :room, home: home
            100.times do
              FactoryBot.create :reading, room: room, key: 'temperature'
              FactoryBot.create :reading, room: room, key: 'humidity'
            end
          end
        end

        it { expect(response).to have_http_status(:success) }
      end
    end
  end
end
