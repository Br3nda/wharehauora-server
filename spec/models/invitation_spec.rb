# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject(:invitation) { FactoryBot.create(:invitation) }

  it { is_expected.to be_valid }
  it { is_expected.to be_pending }

  describe '#to_param' do
    subject(:id) { invitation.to_param }

    it { is_expected.to eq invitation.token }
  end

  context 'with a blank email' do
    before { invitation.email = nil }

    it { is_expected.not_to be_valid }
  end

  context 'with a blank token' do
    before { invitation.token = nil }

    it { is_expected.not_to be_valid }
  end

  context 'with a token that already exists' do
    let(:existing_invitation) { FactoryBot.create(:invitation) }

    before { invitation.token = existing_invitation.token }

    it { is_expected.not_to be_valid }
  end

  describe '.pending' do
    before { invitation }

    it 'includes the invitation' do
      expect(Invitation.pending).to include(invitation)
    end

    context 'when the invitation has been declined' do
      before { invitation.update!(status: :declined) }

      it 'does not include the invitation' do
        expect(Invitation.pending).not_to include(invitation)
      end
    end
  end
end
