require 'rails_helper'

RSpec.feature 'Front page', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, home_type: home_type }
  let(:home_type) { FactoryGirl.create :home_type }
  let(:room_type) { FactoryGirl.create :room_type }
  let(:sensor) { FactoryGirl.create :sensor, room_type: room_type }
  before do
    100.times do
      FactoryGirl.create :reading,
                         sub_type: MySensors::SetReq::V_TEMP,
                         value: 20.1,
                         sensor: sensor
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
