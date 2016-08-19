class Hand
  include Comparable
  attr_reader :cards

  TYPES = %w(
    straight_flush
    four_of_a_kind
    full_house
    flush
    straight
    three_of_a_kind
    two_pair
    pair
  )

  def initialize(cards)
    @cards =
      case cards
      when Array
        cards.map { |card| card.is_a?(Card) ? card : Card.new(card) }
      when String
        cards.split(" ").map {|s| Card.new(s)}
      else
        raise ArgumentError.new("Input must be a string or array")
      end

    validate!
    sort_cards!
  end

  def <=>(other_hand)
    winner = Matchup.new(self, other_hand).winner
    return  1 if winner == self
    return  0 if winner == nil
    return -1 if winner == other_hand
  end

  def display
    puts cards.join(" ")
  end

  def suits
    @suits ||= cards.map(&:suit)
  end

  def values
    @values ||= cards.map(&:value)
  end

  def int_values
    @int_values ||= cards.map(&:to_i)
  end

  def num_uniq_values
    @num_uniq_values ||= values.uniq.size
  end

  def wheel?
    values == %w(A 5 4 3 2)
  end

  def flush?
    suits.all? { |suit| suit == suits.first }
  end

  def straight?
    wheel? || (int_values.first == int_values.last + 4 && num_uniq_values == 5)
  end

  def straight_flush?
    flush? && straight?
  end

  def full_house?
    same_values?(0, 2) && same_values?(3, 4)
  end

  def four_of_a_kind?
    same_values?(0, 3)
  end

  def three_of_a_kind?
    same_values?(0, 2) && num_uniq_values == 3
  end

  def two_pair?
    same_values?(0, 1) && same_values?(2, 3) && num_uniq_values == 3
  end

  def pair?
    same_values?(0, 1) && num_uniq_values == 4
  end

  def rank
    (TYPES.find { |type| send("#{type}?".to_sym) } || "high_card").gsub('_', ' ')
  end

  private
  # sort cards by their value multiplicity in descending order
  # e.g. sort Js 2s Jh 4s 2c as Js Jh 2s 2c 4s
  def sort_cards!
    vals = cards.map(&:to_i)
    counts = Hash[vals.map { |val| [val, vals.count(val)] }]
    @cards.sort_by! { |card| [-counts[card.to_i], -card.to_i] }
  end

  def same_values?(start, stop)
    vals = values[start..stop]
    vals.all? { |value| value == vals.first }
  end

  def validate!
    validate_length!
    check_for_duplicates!
  end

  def validate_length!
    raise ArgumentError.new("A hand must contain 5 cards") unless cards.size == 5
  end

  def check_for_duplicates!
    unless cards.map(&:to_s).uniq.size == 5
      raise ArgumentError.new("A hand cannot contain duplicate cards")
    end
  end
end
