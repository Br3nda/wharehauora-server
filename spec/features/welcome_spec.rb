require 'rails_helper'

RSpec.feature 'Front page', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let!(:public_home) { FactoryGirl.create :home, home_type: home_type, is_public: true }
  let!(:private_home) { FactoryGirl.create :home, home_type: home_type, is_public: false }
  let!(:public_room) { FactoryGirl.create :room, home: public_home, room_type: room_type }
  let!(:private_room) { FactoryGirl.create :room, home: private_home, room_type: room_type }
  let(:home_type) { FactoryGirl.create :home_type }
  let(:room_type) { FactoryGirl.create :room_type, min_temperature: 18, max_temperature: 30 }

  before do
    100.times { FactoryGirl.create :reading, room: public_room }
    100.times { FactoryGirl.create :reading, room: private_room }
  end

  shared_examples 'displays only public data' do
    before { visit '/' }
    it { expect(page).to have_text('Live demo data') }
    it 'displays public room name' do
      expect(page).to have_text(public_room.name)
    end
    it 'does not show private room' do
      expect(page).not_to have_text(private_room.name)
    end
    it 'offers analyse button' do
      expect(page).to have_link('Analyse')
    end
    it 'offers analyse button' do
      expect(page).to have_link('Analyse')
    end
  end

  shared_examples 'can analyse public home' do
    before { visit '/' }
    it 'allows viewing room' do
      click_link 'Analyse'
      expect(page).to have_text(public_room.name)
    end
  end

  context 'user is not signed in' do
    describe 'views front page' do
      include_examples 'displays only public data'
      include_examples 'can analyse public home'
    end
  end

  context 'user is signed in as normal user' do
    background { login_as(user) }
    describe 'views front page' do
      include_examples 'displays only public data'
      include_examples 'can analyse public home'
    end
  end

  context 'user is owner of public home' do
    background { login_as(public_home.owner) }
    describe 'views front page' do
      include_examples 'displays only public data'
      include_examples 'can analyse public home'
    end
  end
end
