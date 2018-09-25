# frozen_string_literal: true

require 'rails_helper'
RSpec.describe HomesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user)          { FactoryBot.create(:user)                                       }
  let(:admin_role)    { FactoryBot.create(:role, name: 'janitor')                      }
  let(:admin_user)    { FactoryBot.create(:user, roles: [admin_role])                  }
  let!(:home)         { FactoryBot.create(:home, owner_id: user.id)                    }
  let!(:room)         { FactoryBot.create(:room, home: home)                           }
  let!(:another_home) { FactoryBot.create(:home, name: "someone else's home")          }
  let!(:public_home)  { FactoryBot.create(:home, name: 'public home', is_public: true) }

  let(:faraday_double) { double(Faraday, basic_auth: nil, post: '') }

  before do
    ENV['CLOUDMQTT_URL'] = 'mqtt://bob:bobpassword@qwerty.mqttsomewhere.nz:12345/hey'
    allow(Faraday).to receive(:new).and_return faraday_double
  end

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    describe 'GET new' do
      before { get :new }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    pending 'PUT create'

    describe 'DELETE destroy' do
      describe 'my home' do
        before { delete :destroy, params: { id: home.id } }

        it { expect(response).to redirect_to(new_user_session_path) }
      end

      describe "someone else's home" do
        before { delete :destroy, params: { id: another_home.id } }

        it { expect(response).to redirect_to(new_user_session_path) }
      end

      describe 'public home' do
        before { delete :destroy, params: { id: public_home.id } }

        it { expect(response).to redirect_to(new_user_session_path) }
      end
    end

    describe 'GET edit for a home' do
      before { get :edit, params: { id: home.to_param } }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    pending 'GET index'
    describe 'GET new' do
      before { get :new }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:home)).to be_a_new(Home) }
    end

    describe 'PUT create' do
      subject { assigns(:home) }

      describe 'Creating a home' do
        before { put :create, params: { home: { name: 'My new home' } } }

        it { expect(subject.name).to eq 'My new home' }
        it { expect(subject.owner).to eq user }
      end

      describe 'creating a home for someone else' do
        let(:params) do
          {
            home: { name: 'Bob\'s home' },
            owner: { email: 'bob@example.com' }
          }
        end

        before { put :create, params: params }

        it { expect(subject.name).to eq "Bob\'s home" }
        it { expect(subject.owner).to eq user }
      end
    end

    describe 'DELETE destroy' do
      describe 'my home' do
        before { delete :destroy, params: { id: home.id } }

        it { expect(response).to redirect_to(homes_path) }
      end

      describe "someone else's home" do
        before { delete :destroy, params: { id: another_home.id } }

        it { expect(response).to have_http_status(:not_found) }
      end

      describe 'public home' do
        before { delete :destroy, params: { id: public_home.id } }

        it { expect(response).to redirect_to(root_path) }
      end
    end

    describe '#update' do
      before { patch :update, params: { id: home.to_param, home: { name: 'New home name' } } }

      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      before { get :edit, params: { id: another_home.to_param } }

      it { expect(response).to have_http_status(:not_found) }
    end
  end # end signed in

  context 'signed in as admin/janitor' do
    before { sign_in admin_user }

    describe 'GET index' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template('index') }
    end

    describe 'GET new' do
      before { get :new }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
    end

    pending 'PUT create'

    describe 'DELETE destroy' do
      describe 'my home' do
        before { delete :destroy, params: { id: home.id } }

        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq home.id }
      end

      describe "someone else's home" do
        before { delete :destroy, params: { id: another_home.id } }

        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq another_home.id }
      end

      describe 'public home' do
        before { delete :destroy, params: { id: public_home.id } }

        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq public_home.id }
      end
    end

    describe '#update' do
      before { patch :update, params: { id: home.to_param, home: { name: 'New home name' } } }

      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      before { get :edit, params: { id: another_home.to_param } }

      it { expect(response).to have_http_status(:success) }
    end
  end
end
