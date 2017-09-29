class Hand
  include Comparable
  attr_reader :cards

  RANKS = %i{
    straight_flush
    four_of_a_kind
    full_house
    flush
    straight
    three_of_a_kind
    two_pair
    pair
  }

  def initialize(cards)
    @cards = parse_cards(cards)

    validate_cards!
    sort_cards!
  end

  def <=>(other_hand)
    winner = Matchup.new(self, other_hand).winner
    return  1 if winner == self
    return  0 if winner == nil
    return -1 if winner == other_hand
  end

  def rank
    @rank ||= RANKS.find { |rank| send("#{rank}?") } || :high_card
  end

  def rank_idx
    RANKS.index(rank) || RANKS.size
  end

  def display
    puts cards.join(" ")
  end

  def suits
    cards.map(&:suit)
  end

  def values
    cards.map(&:value)
  end

  def nums
    wheel? ? [5,4,3,2,1] : cards.map(&:to_i)
  end

  def straight_flush?
    flush? && straight?
  end

  def flush?
    suits.uniq.size == 1
  end

  def straight?
    wheel? || (nums.first == nums.last + 4 && form == :abcde)
  end

  def wheel?
    values == %w(A 5 4 3 2)
  end

  def four_of_a_kind?
    form == :aaaab
  end

  def full_house?
    form == :aaabb
  end

  def three_of_a_kind?
    form == :aaabc
  end

  def two_pair?
    form == :aabbc
  end

  def pair?
    form == :aabcd
  end

  private
  # sort cards by their value multiplicity in descending order
  # e.g. sort Js 2s Jh 4s 2c as Js Jh 2s 2c 4s
  def sort_cards!
    @cards.sort_by! { |card| [-value_count[card.value], -card.to_i] }
  end

  def value_count
    @value_count ||=
      values.each_with_object(Hash.new(0)) { |v, hsh| hsh[v] += 1 }
  end

  def counts
    value_count.values.sort_by { |count| -count }
  end

  def form
    @form ||=
      counts.zip(%w(a b c d e)).map { |count, l| l*count }.join.to_sym
  end

  def parse_cards(cards)
    case cards
    when Array  then cards.map { |card| card.is_a?(Card) ? card : Card.new(card) }
    when String then cards.split(' ').map { |s| Card.new(s) }
    else raise ArgumentError, 'Input must be a string or array'
    end
  end

  def validate_cards!
    validate_length!
    check_for_duplicates!
  end

  def validate_length!
    unless cards.size == 5
      raise ArgumentError, 'A hand must contain 5 cards'
    end
  end

  def check_for_duplicates!
    if duplicates?
      raise ArgumentError, 'A hand cannot contain duplicate cards'
    end
  end

  def duplicates?
    cards.map(&:to_s).uniq.size < 5
  end
end
