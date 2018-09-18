# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingService, type: :model do
  describe '#rating_text' do
    it { expect(RatingService.rating_text('A')).to eq 'Excellent' }
    it { expect(RatingService.rating_text('B')).to eq 'Good' }
    it { expect(RatingService.rating_text('C')).to eq 'Barely acceptable' }
    it { expect(RatingService.rating_text('D')).to eq 'Bad' }
    it { expect(RatingService.rating_text('F')).to eq 'Very bad' }
    it { expect(RatingService.rating_text('Z')).to eq 'Unknown' }
  end
end
