# frozen_string_literal: true

class RatingService
  def self.rating_text(rating)
    case rating
    when 'A'
      'Excellent'
    when 'B'
      'Good'
    when 'C'
      'Barely acceptable'
    when 'D'
      'Bad'
    when 'F'
      'Very bad'
    else
      'Unknown'
    end
  end
end
