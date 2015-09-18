class Matchup
  attr_reader :hand1, :hand2

  def initialize(hand1, hand2)
    @hand1, @hand2 = hand1, hand2
  end

  def winner
    Hand::TYPES.each do |type|
      # build the boolean type check method
      is_type = "#{type}?".to_sym

      # check whether either hand is of the type
      if hand1.send(is_type) && hand2.send(is_type)
        return same_type_winner
      elsif hand1.send(is_type)
        return hand1
      elsif hand2.send(is_type)
        return hand2
      end
    end

    # both hands are high card rank and can be compared by
    # comparing values
    return same_type_winner
  end

  private
  # for two hands of the same type (straight, flush, etc):
  # returns the winner by sorting the hands' numeric values
  # and then comparing value pairs in descending order
  def same_type_winner

    # check for the special case where one hand is a wheel
    if hand1.wheel? && hand2.wheel?
      return nil
    elsif hand1.wheel?
      return hand2
    elsif hand2.wheel?
      return hand1
    end

    # compare the numeric value pairs
    values1, values2 = [hand1, hand2].map(&:uniq_values_sorted_by_count)
    values1.zip(values2).each do |v1, v2|
      if v1 > v2
        return hand1
      elsif v2 > v1
        return hand2
      end
    end
    return nil
  end

  # def validate!
  #   all_cards = hand1.cards + hand2.cards
  #   unless all_cards.map(&:to_s).uniq.size == 10
  #     raise "Hands cannot share cards"
  #   end
  # end
end
