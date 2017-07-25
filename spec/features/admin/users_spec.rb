require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let!(:admin_user) { FactoryGirl.create(:admin) }
  let!(:user) { FactoryGirl.create :user }

  context '#index' do
    shared_examples 'cannot see users' do
      before { visit '/admin/users' }
      it { expect(page).not_to have_text(user.email) }
    end

    context 'not signed in' do
      include_examples 'cannot see users'
    end

    context 'Normal user' do
      background { login_as(user) }
      include_examples 'cannot see users'
    end

    context 'Logged in as admin' do
      background { login_as(admin_user) }
      before { visit '/admin/users' }
      it { expect(page).to have_text(admin_user.email) }
      it { expect(page).to have_text(user.email) }
    end
  end

  pending '#edit'
  pending '#update'
  pending '#destroy'
end
