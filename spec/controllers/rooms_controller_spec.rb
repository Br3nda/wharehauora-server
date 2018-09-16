# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:bedroom) { FactoryBot.create(:room_type, name: 'bedroom') }

  let(:user) { FactoryBot.create(:user) }
  let(:home)   { FactoryBot.create(:home, owner_id: user.id)              }
  let(:room)   { FactoryBot.create(:room, home: home, room_type: bedroom) }
  let(:sensor) { FactoryBot.create(:sensor, room: room, node_id: '1100')  }

  shared_examples 'Test as all user types' do
    context 'Not signed in' do
      describe 'GET show' do
        before { get :show, params: { home_id: room.home.id, id: room.id } }

        it { expect(response).not_to have_http_status(:success) }
      end
    end

    context 'user is signed in as owner' do
      before { sign_in user }

      describe 'GET index' do
        before { get :index, params: { home_id: room.home.id } }

        it { expect(response).to have_http_status(:success) }

        context 'one room' do
          it 'Only finds our one room' do
            expect(assigns(:rooms)).to eq([room])
          end

          context 'no unassigned_sensors' do
            it { expect(assigns(:unassigned_sensors)).to eq([]) }
          end

          context '1 unassigned_sensors' do
            let!(:sensor) { FactoryBot.create :unassigned_sensor, home: home, room: nil }

            it { expect(assigns(:unassigned_sensors)).to eq([sensor]) }
          end

          context '30 unassigned_sensors' do
            before { FactoryBot.create_list(:unassigned_sensor, 30, home: home, room: nil) }

            it { expect(assigns(:unassigned_sensors).size).to eq 30 }
          end
        end
      end

      describe 'GET show' do
        before { get :show, params: { home_id: room.home.id, id: room.id } }

        it { expect(response).to have_http_status(:success) }
      end

      describe '#update' do
        before do
          patch :update, params: {
            home_id: room.home.id, id: room.to_param,
            room: { name: 'Living room' }
          }
        end

        it { expect(response).to redirect_to home_rooms_path(home) }
      end
    end

    context 'user is signed in as whānau' do
      let(:whanau) { FactoryBot.create :user }

      before do
        home.users << whanau
        sign_in whanau
      end

      describe 'GET show' do
        before { get :show, params: { home_id: room.home.id, id: room.id } }

        it { expect(response).to have_http_status(:success) }
      end

      describe '#update' do
        before do
          patch :update, params: {
            home_id: room.home.id, id: room.to_param,
            room: { name: 'Living room' }
          }
        end

        it { expect(response).to have_http_status(:redirect) }
      end
    end

    context "Trying to access another users's data" do
      before { sign_in user }

      describe "GET edit for someone else's home" do
        let(:home) { FactoryBot.create(:home) }
        let(:room) { FactoryBot.create(:room, home: home) }

        describe '#index' do
          before { get :index, params: { home_id: home.id } }

          it { expect(response).to have_http_status(:not_found) }
        end

        describe '#show' do
          before { get :show, params: { home_id: home.id, id: room.to_param } }

          it { expect(response).to have_http_status(:not_found) }
        end

        describe '#edit' do
          before { get :edit, params: { home_id: home.id, id: room.to_param } }

          it { expect(response).to have_http_status(:not_found) }
        end
      end
    end
  end

  context 'No other whanau' do
    include_examples 'Test as all user types'
  end

  context 'Homes with lots of Whanau' do
    before { FactoryBot.create_list(:home_viewer, 7, home: home) }

    it { expect(home.users.size).to eq(7) }
    include_examples 'Test as all user types'
  end
end
