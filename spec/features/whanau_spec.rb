require 'rails_helper'

RSpec.feature 'Whānau', type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:friend) { FactoryBot.create :user }
  let(:home) { FactoryBot.create :home, owner_id: user.id }

  context 'With a whānau member' do
    let!(:viewer) { home.home_viewers.create!(user: friend) }

    background { login_as(user) }

    scenario 'Views their whānau' do
      visit home_home_viewers_path(home)
      expect(page).to have_text(friend.email)
    end

    scenario 'Removes their friend' do
      visit home_home_viewers_path(home)
      within(:css, "[data-home-viewer-id=\"#{viewer.id}\"]") do
        find(:css, 'a[data-method="delete"]').click
      end
      expect(page).to have_current_path(home_home_viewers_path(home))
      expect(page).not_to have_text(friend.email)
    end
  end
end
