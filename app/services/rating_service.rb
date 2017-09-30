class RatingService
  def self.rating_text(rating) # rubocop:disable Metrics/MethodLength
    case rating
    when 'A'
      'Excellent'
    when 'B'
      'Good'
    when 'C'
      'Mediocre'
    when 'D'
      'Poor'
    when 'F'
      'Very poor'
    else
      'unknown'
    end
  end
end
