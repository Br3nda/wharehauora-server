require 'rails_helper'

RSpec.describe Admin::HomeTypesController, type: :controller do
  include Devise::Test
  shared_examples 'redirect to login' do
    it { expect(response).to redirect_to(new_user_session_path) }
  end
  shared_examples 'redirect to home' do
    it { expect(response).to redirect_to(root_path) }
  end
  let(:home_type) { FactoryGirl.create(:home_type) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      include_examples 'redirect to login'
    end
    describe 'GET new' do
      before { get :new }
      include_examples 'redirect to login'
    end
    describe 'PUT create' do
      before { put :create }
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
    describe 'GET new' do
      before { get :new }
      include_examples 'redirect to home'
    end
    describe 'PUT create' do
      before { put :create }
      include_examples 'redirect to home'
    end
    describe 'DELETE destroy' do
      before { delete :destroy, id: home_type.id }
      include_examples 'redirect to home'
    end
  end
end
