# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::HomeTypesController, type: :controller do
  include Devise::Test
  shared_examples 'redirect to login' do
    it { is_expected.to redirect_to(new_user_session_path) }
  end
  shared_examples 'redirect to home' do
    it { is_expected.to redirect_to(root_path) }
  end
  subject { response }

  let!(:home_type)    { FactoryBot.create(:home_type)                 }
  let(:user)          { FactoryBot.create(:user)                      }
  let(:admin_role)    { FactoryBot.create(:role, name: 'janitor')     }
  let(:admin_user)    { FactoryBot.create(:user, roles: [admin_role]) }
  let(:valid_params)  { { name: Faker.name }                          }

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }

      include_examples 'redirect to login'
    end

    describe 'GET new' do
      before { get :new, params: valid_params }

      include_examples 'redirect to login'
    end

    describe 'PUT create' do
      before { put :create }

      include_examples 'redirect to login'
    end

    describe 'GET edit' do
      before { get :edit, params: { id: home_type.id } }

      include_examples 'redirect to login'
    end

    describe 'DELETE destroy' do
      before { delete :destroy, params: { id: home_type.id } }

      include_examples 'redirect to login'
    end
  end

  context 'signed in as normal user' do
    before { sign_in user }

    describe 'GET index' do
      before { get :index }

      include_examples 'redirect to home'
    end

    describe 'GET show' do
      before { get :show, params: { id: home_type.id } }
    end

    describe 'GET new' do
      before { get :new, params: valid_params }

      include_examples 'redirect to home'
    end

    describe 'PUT create' do
      before { put :create }

      include_examples 'redirect to home'
    end

    describe 'GET edit' do
      before { get :edit, params: { id: home_type.id } }

      include_examples 'redirect to home'
    end

    describe 'DELETE destroy' do
      before { delete :destroy, params: { id: home_type.id } }

      include_examples 'redirect to home'
    end
  end

  context 'signed in as admin' do
    before { sign_in admin_user }

    describe 'GET index' do
      before { get :index }

      it { is_expected.to have_http_status(:success) }
      it { expect(assigns(:home_types)).to eq([home_type]) }
    end

    describe 'GET new' do
      before { get :new, params: { home_type: valid_params } }

      it { is_expected.to have_http_status(:success) }
    end

    describe 'PUT create,' do
      it do
        expect do
          put :create, params: { home_type: valid_params }
        end.to change(HomeType, :count).by(1)
      end
    end

    describe 'GET edit' do
      before { get :edit, params: { id: home_type.id } }

      it { is_expected.to have_http_status(:success) }
      it { expect(assigns(:home_type)).to eq(home_type) }
    end

    describe 'DELETE destroy' do
      it do
        expect do
          delete :destroy, params: { id: home_type.id }
        end.to change(HomeType, :count).by(-1)
      end
    end
  end
end
