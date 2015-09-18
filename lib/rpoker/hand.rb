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
  end

  def <=>(other_hand)
    winner = Matchup.new(self, other_hand).winner
    return  1 if winner == self
    return  0 if winner == nil
    return -1 if winner == other_hand
  end

  def display
    print cards.map { |card| card.to_s }.join(" ")
  end

  def suits
    @suits ||= cards.map(&:suit)
  end

  def values
    @values ||= cards.map(&:value)
  end

  def num_values
    @num_values ||= cards.map(&:num_value)
  end

  def sorted_values
    @sorted_values ||= num_values.sort.reverse
  end

  # def values_sorted_by_count
  #   @values_sorted_by_count ||=
  #     [4,3,2,1].inject([]) { |sorted, n|
  #       sorted += sorted_values.select { |value| sorted_values.count(value) == n } }
  # end

  # sort card values by their multiplicity in descending order
  # e.g. for the hand Js 2s Jh 4s 2c the method returns [11, 11, 2, 2, 4]
  def values_sorted_by_count
    @values_sorted_by_count ||= sort_values_by_count
  end

  # alternate (optimized?) implementation
  def sort_values_by_count
    vals = sorted_values.dup
    counts = Hash[vals.map { |value| [value, vals.count(value)] }]

    [4, 3, 2, 1].inject([]) do |sorted_by_count, n|
      vals_with_count, vals = vals.partition { |value| counts[value] == n }
      sorted_by_count + vals_with_count
    end
  end

  # sort distinct card values by their multiplicity in descending order
  # e.g. for the hand Js 2s Jh 4s 2c the method returns [11, 2, 4]
  def uniq_values_sorted_by_count
    @uniq_values_sorted_by_count ||= values_sorted_by_count.uniq
  end

  def num_uniq_values
    @num_uniq_values ||= values.uniq.size
  end

  def same_values_in_sorted?(start, stop)
    values_slice = values_sorted_by_count[start..stop]
    values_slice.all? { |value| value == values_slice.first }
  end

  def wheel?
    sorted_values == [14, 5, 4, 3, 2]
  end

  def flush?
    suits.all? { |suit| suit == suits.first }
  end

  def straight?
    wheel? || (sorted_values.first == sorted_values.last + 4 && num_uniq_values == 5)
  end

  def straight_flush?
    flush? && straight?
  end

  def full_house?
    same_values_in_sorted?(0, 2) && same_values_in_sorted?(3, 4)
  end

  def four_of_a_kind?
    same_values_in_sorted?(0, 3)
  end

  def three_of_a_kind?
    same_values_in_sorted?(0, 2) && num_uniq_values == 3
  end

  def two_pair?
    same_values_in_sorted?(0, 1) && same_values_in_sorted?(2, 3) && num_uniq_values == 3
  end

  def pair?
    same_values_in_sorted?(0, 1) && num_uniq_values == 4
  end

  def rank
    (TYPES.find { |type| send("#{type}?".to_sym) } || "high_card").gsub('_', ' ')
  end

  private

  def validate!
    validate_length!
    check_for_duplicates!
  end

  def validate_length!
    raise ArgumentError.new("A hand must contain 5 cards") unless cards.size == 5
  end

  def check_for_duplicates!
    unless cards.map(&:to_s).uniq.size == 5
      raise ArgumentError.new("By default, a hand cannot contain duplicate cards")
    end
  end
end
