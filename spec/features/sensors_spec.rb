require 'rails_helper'

RSpec.feature 'Sensors', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:janitor) { FactoryGirl.create :role, name: 'janitor' }
  let(:admin_user) { FactoryGirl.create :user, roles: [janitor] }

  let(:home_type) { FactoryGirl.create :home_type }
  let(:home) { FactoryGirl.create :home, owner_id: user.id, home_type: home_type, name: 'Toku whare whanau' }

  subject { page }

  # subject { page }
  context 'Normal user' do
    background { login_as(home.owner) }
    # we see a list of sensors on the Homes#index page
    context 'rooms#index' do
      context '1 unassigned sensor' do
        let!(:sensor) { FactoryGirl.create :sensor, home: home }
        before { visit "/homes/#{sensor.home_id}/rooms" }
        it { is_expected.to have_text 'new sensors detected' }
        it { is_expected.to have_link 'Assign to room' }
        it { is_expected.to have_text sensor.node_id }
      end

      context 'no sensors' do
        before { visit "/homes/#{home.id}/rooms" }
        it { is_expected.not_to have_text 'new sensors detected' }
        it { is_expected.not_to have_link 'Assign to room' }
      end
    end

    context 'assign sensor' do
      let!(:sensor) { FactoryGirl.create :sensor, home: home }
      context 'to a new room' do
        before do
          visit "/homes/#{home.id}/rooms"
          click_link 'Assign to room'
        end
        pending 'fill in form and save'
      end
      context 'to an existing room' do
        let!(:existing_room) { FactoryGirl.create :room, name: 'library', home: home }
        before do
          visit "/homes/#{home.id}/rooms"
          click_link 'Assign to room'
        end
        it { is_expected.to have_text 'library' }
        pending 'selected existing room and save'
      end
    end
  end
end
