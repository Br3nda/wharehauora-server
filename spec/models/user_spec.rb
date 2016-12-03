require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'admin') }

  describe '#role?' do
    it 'checks if the user has a specific role' do
      expect(user.role?(admin_role.name)).to eq false
      user.roles << admin_role
      expect(user.role?(admin_role.name)).to eq true
    end
  end
end
