require 'rails_helper'

RSpec.describe Admin::CleanerController, type: :controller do
  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
