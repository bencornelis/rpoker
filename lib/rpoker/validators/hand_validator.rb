class HandValidator
  CARD_COUNT = 5

  def initialize(hand)
    @cards = hand.cards
  end

  def validate
    validate_card_count
    validate_no_duplicates
  end

  private

  attr_reader :cards

  def validate_card_count
    unless cards.size == CARD_COUNT
      raise ArgumentError, "A hand must contain #{CARD_COUNT} cards"
    end
  end

  def validate_no_duplicates
    if duplicates?
      raise ArgumentError, 'A hand cannot contain duplicate cards'
    end
  end

  def duplicates?
    uniq_card_count < CARD_COUNT
  end

  def uniq_card_count
    cards.map(&:to_s).uniq.size
  end
end

