require "spec_helper"

describe Hand do
  let(:test_hand) { Hand.new("As 3h Jd Qs 3s") }

  it "has 5 cards" do
    expect(test_hand.cards.size).to eq(5)
    expect(test_hand.cards).to all( be_a(Card) )
  end

  describe "#suits" do
    it "returns an array of the card suits" do
      expect(test_hand.suits).to eq(%w(s h d s s))
    end

    it "caches the result" do
      expect(test_hand.cards).to receive(:map).once.and_call_original
      2.times { test_hand.suits }
    end
  end

  describe "#values" do
    it "returns an array of the card values" do
      expect(test_hand.values).to eq(%w(A 3 J Q 3))
    end

    it "caches the result" do
      expect(test_hand).to receive(:cards).once.and_call_original
      2.times { test_hand.values }
    end
  end

  describe "#num_values" do
    it "returns an array of the numeric card values" do
      expect(test_hand.num_values).to eq([14, 3, 11, 12, 3])
    end

    it "caches the result" do
      expect(test_hand).to receive(:cards).once.and_call_original
      2.times { test_hand.num_values }
    end
  end

  describe "#sorted_values" do
    it "returns a sorted array of the numeric card values" do
      expect(test_hand.sorted_values).to eq([14, 12, 11, 3, 3])
    end

    it "caches the result" do
      expect(test_hand).to receive(:num_values).once.and_call_original
      2.times { test_hand.sorted_values }
    end
  end

  describe "#values_sorted_by_count" do
    it "sorts values by multiplicity in descending order" do
      expect(test_hand.values_sorted_by_count).to eq([3, 3, 14, 12, 11])
    end
  end

  describe "#uniq_values_sorted_by_count" do
    it "returns uniq values sorted by multiplicity" do
      expect(test_hand.uniq_values_sorted_by_count).to eq([3, 14, 12, 11])
    end

    it "caches the result" do
      expect(test_hand).to receive(:values_sorted_by_count).once.and_call_original
      2.times { test_hand.uniq_values_sorted_by_count }
    end
  end

  describe "#num_uniq_values" do
    it "calculates the number of unique values" do
      expect(test_hand.num_uniq_values).to eq(4)
    end
  end

  describe "#same_values_in_sorted?" do
    it "returns true when values sorted by multiplicity are all the same in given range" do
      expect(test_hand.same_values_in_sorted?(0, 1)).to be(true)
    end

    it "returns false otherwise" do
      expect(test_hand.same_values_in_sorted?(1, 3)).to be(false)
    end
  end

  let(:wheel)           { Hand.new("As 3c 4h 2d 5c") }
  let(:pair)            { Hand.new("2c 4d 5h 4c Js") }
  let(:two_pair)        { Hand.new("2c 4d 5h 4c 5s") }
  let(:three_of_a_kind) { Hand.new("2c 4d 5h 5c 5s") }
  let(:straight)        { Hand.new("4s 7h 5s 6h 8d") }
  let(:flush)           { Hand.new("9h Jh Ah 2h 3h") }
  let(:full_house)      { Hand.new("3c 3d Qs Qh 3h") }
  let(:straight_flush)  { Hand.new("8s 9s Ts Js Qs") }

  describe "#wheel?" do
    it "sees if the hand is a wheel" do
      expect(wheel.wheel?).to be(true)
      expect(pair.wheel?).to be(false)
    end
  end

  describe "#flush?" do
    it "sees if the hand is a flush" do
      expect(flush.flush?).to be(true)
      expect(three_of_a_kind.flush?).to be(false)
    end
  end

  describe "#straight?" do
    it "sees if the hand is a straight" do
      expect(straight.straight?).to be(true)
      expect(two_pair.straight?).to be(false)
    end
  end

  describe "#straight_flush?" do
    it "sees if the hand is a straight flush" do
      expect(straight_flush.straight_flush?).to be(true)
      expect(straight.straight_flush?).to be(false)
      expect(flush.straight_flush?).to be(false)
    end
  end

  describe "#full_house?" do
    it "sees if the hand is a full house" do
      expect(full_house.full_house?).to be(true)
      expect(three_of_a_kind.full_house?).to be(false)
    end
  end

  describe "three_of_a_kind?" do
    it "sees if the hand is three of a kind" do
      expect(three_of_a_kind.three_of_a_kind?).to be(true)
      expect(pair.three_of_a_kind?).to be(false)
    end
  end

  describe "two_pair?" do
    it "sees if the hand is two pair" do
      expect(two_pair.two_pair?).to be(true)
      expect(pair.two_pair?).to be(false)
    end
  end
end
