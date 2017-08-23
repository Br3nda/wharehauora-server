require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }
  let(:my_friend) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let!(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let!(:another_home) { FactoryGirl.create(:home, name: "someone else's home") }
  let!(:public_home)  { FactoryGirl.create(:home, name: 'public home', is_public: true) }
  let(:invitation) { FactoryGirl.create(:invitation, home: home, inviter: user, email: my_friend.email) }

  context 'not signed in ' do
    describe 'GET show' do
      subject { response }
      before { get :show, id: invitation.to_param }
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'POST create' do
      subject { response }
      before { post :create, home_id: home.to_param }
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'DELETE' do
      it do
        expect(invitation).to be_present
        expect do
          delete :destroy, id: invitation.to_param, home_id: home.id
        end.not_to(change { Invitation.count })
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'signed in as the friend' do
    before { sign_in my_friend }

    describe 'GET show' do
      before { get :show, id: invitation.to_param }
      it { expect(response).to have_http_status(:success) }
    end

    describe 'POST accept' do
      it 'creates a home viewer' do
        expect do
          post :accept, id: invitation.to_param
        end.to(change { home.home_viewers.count }.by(1))
        expect(invitation.reload).to be_accepted
        expect(response).to redirect_to(home_path(home))
      end
    end

    describe 'POST decline' do
      it 'creates a home viewer' do
        expect do
          post :decline, id: invitation.to_param
        end.not_to(change { home.home_viewers })
        expect(invitation.reload).to be_declined
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'POST create' do
      it 'creates an invitation' do
        expect do
          post :create, home_id: home.to_param, invitation: { email: my_friend.email }
        end.to change { home.invitations.count }.by(1)
        expect(response).to redirect_to(home_home_viewers_path(home))
      end
    end

    describe 'DELETE' do
      it 'deletes the invitation' do
        expect(invitation).to be_present
        expect do
          delete :destroy, home_id: home.to_param, id: invitation.to_param
        end.to change { home.invitations.count }.by(-1)
        expect(response).to redirect_to(home_home_viewers_path(home))
      end
    end
  end

  # context 'signed in as admin/janitor' do
  #   before { sign_in admin_user }
  #   describe 'GET index' do
  #     before { get :index, home_id: home.to_param }
  #     it { expect(response).to have_http_status(:success) }
  #   end
  #   describe 'GET new' do
  #     before { get :new, home_id: home.to_param }
  #     it { expect(response).to have_http_status(:success) }
  #     it { expect(response).to render_template(:new) }
  #     it { expect(assigns(:home)).to eq(home) }
  #   end
  #   describe 'PUT create' do
  #     before { put :create, home_id: home.to_param, home_viewer: { user: my_friend.email } }
  #     it { expect(response).to redirect_to(home_home_viewers_path(home)) }
  #     it { expect(assigns(:home)).to eq(home) }
  #   end
  #   describe 'DELETE' do
  #     before { home.users << my_friend }
  #     it do
  #       expect do
  #         delete :destroy, id: my_friend.to_param, home_id: home.id
  #       end.to change { HomeViewer.count }.by(-1)
  #       expect(response).to redirect_to(home_home_viewers_path(home))
  #       expect(assigns(:home)).to eq(home)
  #       expect(assigns(:user)).to eq(my_friend)
  #     end
  #   end
  # end
end
