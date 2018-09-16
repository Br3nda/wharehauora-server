# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:valid_params) { { email: 'bob@example.com' } }
  let(:user)         { FactoryBot.create(:user)     }

  context 'Not signed in' do
    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(user_session_path) }
    end

    describe '#edit' do
      before { get :edit, params: { id: user } }

      it { expect(response).to redirect_to(user_session_path) }
    end

    describe '#update' do
      before { patch :update, params: { id: user, user: valid_params } }

      it { expect(response).to redirect_to(user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(root_path) }
    end

    describe '#edit' do
      before { get :edit, params: { id: user } }

      it { expect(response).to redirect_to(root_path) }
    end

    describe '#update' do
      before { patch :update, params: { id: user, user: valid_params } }

      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'user is admin' do
    let(:admin_role) { FactoryBot.create(:role, name: 'janitor') }
    let(:admin) { FactoryBot.create(:user, roles: [admin_role]) }

    before { sign_in admin }

    describe 'GET index' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
    end

    describe '#edit' do
      before { get :edit, params: { id: user } }

      it { expect(response).to have_http_status(:success) }
    end

    describe '#update' do
      before { patch :update, params: { id: user, user: valid_params } }

      it { expect(response).to redirect_to(admin_users_path) }
    end
  end
end
