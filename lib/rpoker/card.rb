class Card
  attr_reader :value, :suit

  FACES  = %w(T J Q K A)
  SUITS  = %w(h d c s)
  VALUES = %w(2 3 4 5 6 7 8 9) + FACES

  FACE_VALUES = {
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  def initialize(string)
    chars = string.split("")
    raise ArgumentError.new("Too many characters") if chars.size > 2

    @value, @suit = [chars.first.upcase, chars.last.downcase]
    validate!
  end

  def to_s
    "#{@value}#{@suit}"
  end

  def face_card?
    value.to_i.to_s != value
  end

  def to_i
    face_card? ? FACE_VALUES[value] : value.to_i
  end

  private

  def validate!
    raise ArgumentError.new("The first character must be a card value") unless VALUES.include?(value)
    raise ArgumentError.new("The second character must be a suit") unless SUITS.include?(suit)
  end
end
