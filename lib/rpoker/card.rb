class Card
  attr_reader :value, :suit

  FACE_VALUES = {
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  def initialize(string)
    chars = string.split("")
    @value, @suit = [chars.first.upcase, chars.last.downcase]
  end

  def to_s
    "#{@value}#{@suit}"
  end

  def face_card?
    value.to_i.to_s != value
  end

  def num_value
    face_card? ? FACE_VALUES[value] : value.to_i
  end
end
