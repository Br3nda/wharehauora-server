require 'rails_helper'

RSpec.describe Admin::CleanerController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
  end
  context 'signed in as normal user' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'signed in as admin' do
    before { sign_in admin_user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
