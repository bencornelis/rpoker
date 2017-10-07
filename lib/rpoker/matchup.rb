class Matchup
  attr_reader :hand1, :hand2
  def initialize(hand1, hand2)
    @hand1, @hand2 = hand1, hand2
  end

  def winner
    return  1 if hand1.rank_idx < hand2.rank_idx
    return -1 if hand2.rank_idx < hand1.rank_idx
    same_rank_winner
  end

  private
  def same_rank_winner
    hand1.sort!
    hand2.sort!

    value_pairs = hand1.card_values.zip(hand2.card_values)

    value_pairs.each do |v1, v2|
      return  1 if v1 > v2
      return -1 if v2 > v1
    end
    0
  end
end
