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

  def card_suits
    cards.map(&:suit)
  end

  def card_ranks
    cards.map(&:rank)
  end

  def card_values
    wheel? ? [5,4,3,2,1] : cards.map(&:to_i)
  end

  def straight_flush?
    flush? && straight?
  end

  def flush?
    card_suits.uniq.size == 1
  end

  def straight?
    return true if wheel?
    sorted_values = card_values.sort
    sorted_values.last - sorted_values.first == 4 && form == :xxxxx
  end

  def wheel?
    card_ranks.sort == %w(A 2 3 4 5).sort
  end

  def four_of_a_kind?
    form == :AAAAx
  end

  def full_house?
    form == :AAABB
  end

  def three_of_a_kind?
    form == :AAAxx
  end

  def two_pair?
    form == :AABBx
  end

  def pair?
    form == :AAxxx
  end

  def form
    @form ||= compute_form
  end

  # sort cards by their rank multiplicity in descending order
  # e.g. sort 2s Jh 4s Js 2c as Jh Js 2s 2c 4s
  def sort!
    @cards.sort_by! { |card| [-card_rank_to_count[card.rank], -card.to_i] }
  end

  private

  def card_rank_to_count
    @card_rank_to_count ||=
      card_ranks.each_with_object(Hash.new(0)) { |v, hsh| hsh[v] += 1 }
  end

  def compute_form
    card_rank_counts      = card_rank_to_count.values.sort.reverse
    counts_for_duplicates = card_rank_counts.select { |c| c > 1 }

    counts_for_duplicates.zip(['A', 'B'])
      .map { |count, letter| letter * count }.join.ljust(5, 'x').to_sym
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
