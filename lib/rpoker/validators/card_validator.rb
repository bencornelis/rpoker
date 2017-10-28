class CardValidator
  def initialize(card_str)
    @card_str = card_str
  end

  def validate
    validate_string
    validate_char_count
    validate_starts_with_rank
    validate_ends_with_suit
  end

  private

  attr_reader :card_str

  def validate_string
    unless card_str.is_a? String
      raise ArgumentError, 'Input must be a string'
    end
  end

  def validate_char_count
    unless card_str.length == 2
      raise ArgumentError, 'Wrong number of characters'
    end
  end

  def validate_starts_with_rank
    unless rank?(card_str[0])
      raise ArgumentError, 'Input must start with a rank'
    end
  end

  def validate_ends_with_suit
    unless suit?(card_str[1])
      raise ArgumentError, 'Input must end with a suit'
    end
  end

  def rank?(str)
    Card::RANKS.include? str.upcase
  end

  def suit?(str)
    Card::SUITS.include? str.downcase
  end
end


