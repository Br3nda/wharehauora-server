require 'rails_helper'

RSpec.describe RatingService, type: :model do
  describe '#rating_text' do
    it { expect(RatingService.rating_text('A')).to eq 'excellent' }
    it { expect(RatingService.rating_text('B')).to eq 'good' }
    it { expect(RatingService.rating_text('C')).to eq 'barely acceptable' }
    it { expect(RatingService.rating_text('D')).to eq 'bad' }
    it { expect(RatingService.rating_text('F')).to eq 'very bad' }
    it { expect(RatingService.rating_text('Z')).to eq 'unknown' }
  end
end
