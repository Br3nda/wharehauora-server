class RatingService
  def self.rating_text(letter) # rubocop:disable Metrics/MethodLength
    case letter
    when 'A'
      'excellent'
    when 'B'
      'good'
    when 'C'
      'barely acceptable'
    when 'D'
      'bad'
    when 'F'
      'very bad'
    else
      'unknown'
    end
  end

  def self.rating_letter(number)
    return 'A' if number > 95
    return 'B' if number > 75
    return 'C' if number > 50
    return 'D' if number > 25
    'F'
  end
end
