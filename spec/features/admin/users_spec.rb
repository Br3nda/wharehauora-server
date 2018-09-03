# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  subject { page }

  let!(:admin_user) { FactoryBot.create :admin }
  let!(:user)       { FactoryBot.create :user  }
  let!(:user_tahi)  { FactoryBot.create :user  }
  let!(:user_rua)   { FactoryBot.create :user  }
  let!(:user_toru)  { FactoryBot.create :user  }

  shared_examples 'cannot #index' do
    describe '#index' do
      before { visit '/admin/users' }

      it { expect(page).not_to have_text(user_tahi.email) }
      it { expect(page).not_to have_text(user_rua.email) }
      it { expect(page).not_to have_text(user_toru.email) }
    end
  end

  context 'not signed in' do
    include_examples 'cannot #index'
  end

  context 'Normal user' do
    before { login_as(user) }

    include_examples 'cannot #index'
  end

  context 'Logged in as admin' do
    before { login_as(admin_user) }

    describe '#index' do
      before { visit '/admin/users' }

      it { expect(page).to have_text(user_tahi.email) }
      it { expect(page).to have_text(user_rua.email) }
      it { expect(page).to have_text(user_toru.email) }
    end

    describe '#edit' do
      before do
        visit '/admin/users'
        click_link user.email
      end

      it { is_expected.to have_text('Editing User') }
    end

    describe '#update' do
      before do
        visit '/admin/users'
        click_link user.email
        fill_in :user_email, with: 'hiria@example.com'
        click_button 'save'
      end

      it { is_expected.to have_text 'hiria@example.com' }
    end

    describe '#destroy' do
      before do
        visit '/admin/users'
        click_link user.email
        click_button 'delete'
      end

      it { is_expected.not_to have_text user.email }
    end
  end
end
