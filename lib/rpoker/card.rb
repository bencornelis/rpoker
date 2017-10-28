class Card
  attr_reader :rank, :suit

  FACE_TO_NUM = {
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }

  NUMERICS = %w(2 3 4 5 6 7 8 9)
  FACES    = FACE_TO_NUM.keys
  SUITS    = %w(s c d h)
  RANKS    = NUMERICS + FACES

  def initialize(card_str)
    CardValidator.new(card_str).validate

    chars = card_str.chars
    @rank = chars.first.upcase
    @suit = chars.last.downcase
  end

  def to_s
    "#{rank}#{suit}"
  end

  def face?
    FACES.include? rank
  end

  def to_i
    face? ? FACE_TO_NUM[rank] : rank.to_i
  end
end
