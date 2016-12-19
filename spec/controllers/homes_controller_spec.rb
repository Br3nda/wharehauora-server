require 'rails_helper'
RSpec.describe HomesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let!(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let!(:another_home) { FactoryGirl.create(:home, name: "someone else's home") }
  let!(:public_home)  { FactoryGirl.create(:home, name: 'public home', is_public: true) }

  context 'not signed in ' do
    pending 'GET index'
    pending 'GET new'
    pending 'PUT create'

    describe 'DELETE destroy' do
      describe 'my home' do
        before { delete :destroy, id: home.id }
        it { expect(response).to redirect_to(new_user_session_path) }
      end
      describe "someone else's home" do
        before { delete :destroy, id: another_home.id }
        it { expect(response).to redirect_to(new_user_session_path) }
      end
      describe 'public home' do
        before { delete :destroy, id: public_home.id }
        it { expect(response).to redirect_to(new_user_session_path) }
      end
    end

    describe 'GET show for a public home' do
      before { get :show, id: public_home.to_param }
      it { expect(response).to have_http_status(:success) }
    end

    describe 'GET show for a private home' do
      before { get :show, id: another_home.to_param }
      it { expect(response).to have_http_status(:not_found) }
    end

    describe 'GET edit for a home' do
      before { get :edit, id: home.to_param }
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

    pending 'PUT create'

    describe 'DELETE destroy' do
      describe 'my home' do
        before { delete :destroy, id: home.id }
        it { expect(response).to redirect_to(homes_path) }
      end
      describe "someone else's home" do
        before { delete :destroy, id: another_home.id }
        it { expect(response).to have_http_status(:not_found) }
      end
      describe 'public home' do
        before { delete :destroy, id: public_home.id }
        it { expect(response).to redirect_to(root_path) }
      end
    end

    describe 'GET show' do
      describe 'no sensors' do
        before { get :show, id: home.id }
        it { expect(response).to have_http_status(:success) }
      end
      describe 'lots of sensors' do
        before do
          15.times { FactoryGirl.create(:sensor, home: home) }
          get :show, id: home.id
        end
        it { expect(response).to have_http_status(:success) }
      end

      describe "someone else's home" do
        before { get :show, id: another_home.id }
        it { expect(response).to have_http_status(:not_found) }
      end

      describe 'public home' do
        before { get :show, id: public_home.to_param }
        it { expect(response).to have_http_status(:success) }
        it { expect(assigns(:home).id).to eq public_home.id }
      end
    end
    describe '#update' do
      before { patch :update, id: home.to_param, home: { name: 'New home name' } }
      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      before { get :edit, id: another_home.to_param }
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
        before { delete :destroy, id: home.id }
        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq home.id }
      end
      describe "someone else's home" do
        before { delete :destroy, id: another_home.id }
        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq another_home.id }
      end
      describe 'public home' do
        before { delete :destroy, id: public_home.id }
        it { expect(response).to redirect_to(homes_path) }
        it { expect(assigns(:home).id).to eq public_home.id }
      end
    end

    describe 'GET show' do
      describe 'my home no sensors' do
        before { get :show, id: home.id }
        it { expect(response).to have_http_status(:success) }
      end
      describe 'my home lots of sensors' do
        before do
          15.times { FactoryGirl.create(:sensor, home: home) }
          get :show, id: home.id
        end
        it { expect(response).to have_http_status(:success) }
      end

      describe "someone else's home" do
        before { get :show, id: another_home.id }
        it { expect(response).to have_http_status(:success) }
      end

      describe 'public home' do
        before { get :show, id: public_home.to_param }
        it { expect(response).to have_http_status(:success) }
        it { expect(assigns(:home).id).to eq public_home.id }
      end
    end

    describe '#update' do
      before { patch :update, id: home.to_param, home: { name: 'New home name' } }
      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      before { get :edit, id: another_home.to_param }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
