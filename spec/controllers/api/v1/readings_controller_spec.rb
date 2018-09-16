# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ReadingsController, type: :controller do
  let!(:reading) { FactoryBot.create(:reading, room: room, created_at: '2018-09-16 05:56:15 UTC') }
  let(:user)     { room.home.owner                                                                }
  let(:room)     { FactoryBot.create :room                                                        }

  context 'OAuth authenticated ' do
    subject(:data) { JSON.parse response.body }

    describe 'GET #index' do
      before { sign_in user }

      describe '#index' do
        let(:week_start) { reading.created_at.to_s }

        before { get :index, format: :json, params: { room_id: room.id, week: week_start } }

        it { expect(response.status).to eq 200 }
        it { expect(data['readings']['temperature']).to eq ({ '2018-09-16 05:00:00 UTC' => reading.value }) }
      end
    end
  end
end
