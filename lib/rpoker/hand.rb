class Hand
  attr_reader :cards
  def initialize(cards_string)
    @cards = cards_string.split(" ").map {|s| Card.new(s)}
  end

  def beats?(other_hand)
    Ranker.new(self, other_hand).winner == self
  end

  def display
    print cards.map {|card| card.to_s }.join(', ')
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

  # sort card values by their multiplicity in descending order
  # e.g. for the hand Js 2s Jh 4s 2c the method returns [11, 11, 2, 2, 4]
  def values_sorted_by_count
    @values_sorted_by_count ||=
      [4,3,2,1].inject([]) { |sorted, n|
        sorted += sorted_values.select { |value| sorted_values.count(value) == n } }
  end

  # sort distinct card values by their multiplicity in descending order
  # e.g. for the hand Js 2s Jh 4s 2c the method returns [11, 2, 4]
  def uniq_values_sorted_by_count
    @uniq_values_sorted_by_count ||= values_sorted_by_count.uniq
  end

  def num_uniq_values
    @num_uniq_values ||= values.uniq.size
  end

  def same_values?(start, stop)
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
end
