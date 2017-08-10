class Matchup
  attr_reader :hand1, :hand2
  def initialize(hand1, hand2)
    @hand1, @hand2 = hand1, hand2
  end

  def winner
    return hand1 if hand1.rank_idx < hand2.rank_idx
    return hand2 if hand2.rank_idx < hand1.rank_idx
    same_rank_winner
  end

  private
  def same_rank_winner
    hand1.nums.zip(hand2.nums).each do |v1, v2|
      return hand1 if v1 > v2
      return hand2 if v2 > v1
    end
    nil
  end
end
