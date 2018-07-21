# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::HomeTypesController, type: :controller do
  include Devise::Test
  shared_examples 'redirect to login' do
    it { expect(response).to redirect_to(new_user_session_path) }
  end
  shared_examples 'redirect to home' do
    it { expect(response).to redirect_to(root_path) }
  end
  let(:home_type) { FactoryBot.create(:home_type) }
  let(:user) { FactoryBot.create(:user) }
  let(:admin_role) { FactoryBot.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryBot.create(:user, roles: [admin_role]) }
  let(:valid_params) { { name: Faker.name } }

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }

      include_examples 'redirect to login'
    end

    describe 'GET show' do
      before { get :show, id: home_type.to_param }
    end

    describe 'GET new' do
      before { get :new, valid_params.to_param   }

      include_examples 'redirect to login'
    end

    describe 'PUT create' do
      before { put :create }

      include_examples 'redirect to login'
    end

    describe 'GET edit' do
      before { get :edit, id: home_type.to_param }

      include_examples 'redirect to login'
    end

    describe 'DELETE destroy' do
      before { delete :destroy, id: home_type.id }

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
      before { get :show, id: home_type.to_param }
    end

    describe 'GET new' do
      before { get :new, valid_params.to_param   }

      include_examples 'redirect to home'
    end

    describe 'PUT create' do
      before { put :create }

      include_examples 'redirect to home'
    end

    describe 'GET edit' do
      before { get :edit, id: home_type.to_param }

      include_examples 'redirect to home'
    end

    describe 'DELETE destroy' do
      before { delete :destroy, id: home_type.id }

      include_examples 'redirect to home'
    end
  end

  context 'signed in as admin' do
    before { sign_in admin_user }

    describe 'GET index' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
    end

    describe 'GET show' do
      before { get :show, id: home_type.to_param }
    end

    describe 'GET new' do
      before { get :new, home_type: valid_params }

      it { expect(response).to have_http_status(:success) }
    end

    describe 'PUT create,' do
      before { put :create, home_type: valid_params }

      it { expect(response).to redirect_to(admin_home_types_path) }
    end

    describe 'GET edit' do
      before { get :edit, id: home_type.to_param }

      it { expect(response).to have_http_status(:success) }
    end

    describe 'DELETE destroy' do
      before { delete :destroy, id: home_type.id }

      it { expect(response).to redirect_to(admin_home_types_path) }
    end
  end
end
