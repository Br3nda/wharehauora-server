require 'rails_helper'

module Api
  describe UsersController do
    describe 'GET #show' do
      let!(:application) { FactoryGirl.create(:oauth_application) }
      let!(:user)        { FactoryGirl.create(:user) }
      let!(:token) do
        FactoryGirl.create(:oauth_access_token,
                           application: application,
                           resource_owner_id: user.id)
      end

      it 'responds with 200' do
        get :show, format: :json, access_token: token.token
        expect(response.status).to eq 200
      end

      it 'returns the user as json' do
        get :show, format: :json, access_token: token.token
        expect(response.body).to eq user.to_json(only: %i[name email created_at updated_at])
      end

      context 'invalid access token' do
        it 'responds with 401' do
          get :show, format: :json
          expect(response.status).to eq 401
        end
      end
    end
  end
end
