require 'rails_helper'

RSpec.feature 'Front page', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, home_type: home_type }
  let(:room) { FactoryGirl.create :room, home: home }
  let(:home_type) { FactoryGirl.create :home_type }
  let(:room_type) { FactoryGirl.create :room_type }

  before do
    100.times do
      FactoryGirl.create :reading,
                         key: 'temperature',
                         value: 20.1,
                         room: room
      FactoryGirl.create :reading,
                         key: 'humidity',
                         value: 98.3,
                         room: room
    end
  end

  context 'not signed in' do
    scenario 'Views front page' do
      visit '/'
      expect(page).to have_text('Median Temperatures right now')
    end
  end

  context 'Normal user' do
    background { login_as(user) }
    scenario 'Views front page' do
      visit '/'
      expect(page).to have_text('Median Temperatures right now')
    end
  end
end
