# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user)         { FactoryBot.create :user                                         }
  let(:home)         { FactoryBot.create :home, owner: user                            }
  let(:sensor)       { FactoryBot.create :sensor, home: home, node_id: 1, room_id: nil }
  let(:valid_params) { { sensor_id: sensor.id }                                        }

  context 'Not signed in' do
    describe 'GET index' do
      before { get :index, params: valid_params }

      it { expect(response).not_to have_http_status(:success) }
    end
  end

  context 'Signed in as home owner' do
    before { sign_in user }

    describe 'GET index' do
      before do
        @message_one = FactoryBot.create :message, sensor: sensor
        @message_two = FactoryBot.create :message, sensor: sensor

        get :index, params: valid_params
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:messages).last).to eq(@message_one) }
      it { expect(assigns(:messages).first).to eq(@message_two) }
      it { expect(assigns(:messages)).to eq([@message_two, @message_one]) }
    end
  end
end
