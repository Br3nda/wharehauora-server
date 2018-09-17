# frozen_string_literal: true

module RatingsHelper
  def rating_text(room)
    RatingService.rating_text(room.rating)
  end
end
