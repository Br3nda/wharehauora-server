# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeViewersController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user)          { FactoryBot.create(:user)                                       }
  let(:my_friend)     { FactoryBot.create(:user)                                       }
  let(:admin_role)    { FactoryBot.create(:role, name: 'janitor')                      }
  let(:admin_user)    { FactoryBot.create(:user, roles: [admin_role])                  }
  let!(:home)         { FactoryBot.create(:home, owner_id: user.id)                    }
  let!(:another_home) { FactoryBot.create(:home, name: "someone else's home")          }
  let!(:public_home)  { FactoryBot.create(:home, name: 'public home', is_public: true) }

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    describe 'GET new' do
      before { get :new, params: { home_id: home.to_param } }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    describe 'DELETE' do
      it do
        expect do
          delete :destroy, params: { id: my_friend.to_param, home_id: home.id }
        end.not_to(change(HomeViewer, :count))
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET index' do
      before { get :index, params: { home_id: home.to_param } }

      it { expect(response).to have_http_status(:success) }
    end

    describe 'GET new' do
      before { get :new, params: { home_id: home.to_param } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:home)).to eq(home) }
    end

    describe 'DELETE' do
      before { home.users << my_friend }

      it do
        expect do
          delete :destroy, params: { id: my_friend.to_param, home_id: home.id }
        end.to change(HomeViewer, :count).by(-1)
        expect(response).to redirect_to(home_home_viewers_path(home))
        expect(assigns(:home)).to eq(home)
      end
    end
  end

  context 'signed in as admin/janitor' do
    before { sign_in admin_user }

    describe 'GET index' do
      before { get :index, params: { home_id: home.to_param } }

      it { expect(response).to have_http_status(:success) }
    end

    describe 'GET new' do
      before { get :new, params: { home_id: home.to_param } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:home)).to eq(home) }
    end

    describe 'DELETE' do
      before { home.users << my_friend }

      it do
        expect do
          delete :destroy, params: { id: my_friend.to_param, home_id: home.id }
        end.to change(HomeViewer, :count).by(-1)
        expect(response).to redirect_to(home_home_viewers_path(home))
        expect(assigns(:home)).to eq(home)
      end
    end
  end
end
