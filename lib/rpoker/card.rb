class Card
  attr_reader :rank, :suit

  FACE_TO_NUM = {
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }

  def initialize(str)
    validate!(str)

    chars = str.chars
    @rank = chars.first.upcase
    @suit = chars.last.downcase
  end

  def to_s
    "#{rank}#{suit}"
  end

  def face?
    faces.include? rank
  end

  def to_i
    face? ? FACE_TO_NUM[rank] : rank.to_i
  end

  private

  def validate!(str)
    raise ArgumentError, 'Input must be a string'       unless str.is_a? String
    raise ArgumentError, 'Wrong number of characters'   unless str.length == 2
    raise ArgumentError, 'Input must start with a rank' unless rank?(str[0])
    raise ArgumentError, 'Input must end with a suit'   unless suit?(str[1])
  end

  def rank?(str)
    ranks.include? str.upcase
  end

  def suit?(str)
    suits.include? str.downcase
  end

  def ranks
    numerics + faces
  end

  def numerics
    %w(2 3 4 5 6 7 8 9)
  end

  def faces
    %w(T J Q K A)
  end

  def suits
    %w(s c d h)
  end
end
