require "spec_helper"
require "pry"

describe Hand do
  let(:test_hand) { Hand.new("As 3h Jd Qs 3s") }

  it "can be initialized with a string" do
    expect(test_hand.cards.size).to eq(5)
    expect(test_hand.cards).to all( be_a(Card) )
  end

  it "can be initialized with an array of cards" do
    hand = Hand.new(%w(As 3h Jd Qs 3s).map {|s| Card.new(s)})

    expect(hand.cards.size).to eq(5)
    expect(hand.cards).to all( be_a(Card) )
  end

  it "can be initialized with an array of card strings" do
    hand = Hand.new(%w(As 3h Jd Qs 3s))

    expect(hand.cards.size).to eq(5)
    expect(hand.cards).to all( be_a(Card) )
  end

  it "raises an error when the input is not an array or string" do
    expect {
      Hand.new(19)
    }.to raise_error(ArgumentError, "Input must be a string or array")
  end

  it "raises an error if there are not 5 cards" do
    expect {
      Hand.new(%w(As 3h Jd Qs 3s Jc))
    }.to raise_error(ArgumentError, "A hand must contain 5 cards")

    expect {
      Hand.new(%w(As 3h Jd))
    }.to raise_error(ArgumentError, "A hand must contain 5 cards")
  end

  it "raises an error if there are duplicate cards" do
    expect {
      Hand.new(%w(As 3h Jd Jd 3s))
    }.to raise_error(ArgumentError, "A hand cannot contain duplicate cards")
  end

  it "sorts the cards into a canonical order" do
    expect(
      Hand.new(%w(4s 2s Jh 2c Jc)).cards.map(&:value)
      ).to eq %w(J J 2 2 4)
  end

  describe "#suits" do
    it "returns the sorted cards' suits" do
      expect(test_hand.suits).to eq(%w(s h s s d))
    end

    it "caches the result" do
      expect(test_hand.cards).to receive(:map).once.and_call_original
      2.times { test_hand.suits }
    end
  end

  describe "#values" do
    it "returns the sorted cards' values" do
      expect(test_hand.values).to eq(%w(3 3 A Q J))
    end

    it "caches the result" do
      expect(test_hand).to receive(:cards).once.and_call_original
      2.times { test_hand.values }
    end
  end

  describe "#int_values" do
    it "returns the sorted cards' integer values" do
      expect(test_hand.int_values).to eq([3, 3, 14, 12, 11])
    end

    it "caches the result" do
      expect(test_hand).to receive(:cards).once.and_call_original
      2.times { test_hand.int_values }
    end
  end

  describe "#num_uniq_values" do
    it "calculates the number of unique values" do
      expect(test_hand.num_uniq_values).to eq(4)
    end
  end

  describe "#wheel?" do
    it "sees if the hand is a wheel" do
      expect(Hand.new("As 3c 4h 2d 5c").wheel?).to be(true)
      expect(Hand.new("2c 4d 5h 4c Js").wheel?).to be(false)
    end
  end

  describe "#flush?" do
    it "sees if the hand is a flush" do
      expect(Hand.new("9h Jh Ah 2h 3h").flush?).to be(true)
      expect(Hand.new("2c 4d 5h 5c 5s").flush?).to be(false)
    end
  end

  describe "#straight?" do
    it "sees if the hand is a straight" do
      expect(Hand.new("4s 7h 5s 6h 8d").straight?).to be(true)
      expect(Hand.new("2c 4d 5h 4c 5s").straight?).to be(false)
    end
  end

  describe "#straight_flush?" do
    it "sees if the hand is a straight flush" do
      expect(Hand.new("8s 9s Ts Js Qs").straight_flush?).to be(true)
      expect(Hand.new("4s 7h 5s 6h 8d").straight_flush?).to be(false)
      expect(Hand.new("9h Jh Ah 2h 3h").straight_flush?).to be(false)
    end
  end

  describe "#four_of_a_kind?" do
    it "sees if the hand is has four of a kind" do
      expect(Hand.new("Th Tc Ts 3d Td").four_of_a_kind?).to be(true)
      expect(Hand.new("3c 3d Qs Qh 3h").four_of_a_kind?).to be(false)
    end
  end

  describe "#full_house?" do
    it "sees if the hand is a full house" do
      expect(Hand.new("3c 3d Qs Qh 3h").full_house?).to be(true)
      expect(Hand.new("2c 4d 5h 5c 5s").full_house?).to be(false)
    end
  end

  describe "three_of_a_kind?" do
    it "sees if the hand is three of a kind" do
      expect(Hand.new("2c 4d 5h 5c 5s").three_of_a_kind?).to be(true)
      expect(Hand.new("2c 4d 5h 4c Js").three_of_a_kind?).to be(false)
    end
  end

  describe "two_pair?" do
    it "sees if the hand is two pair" do
      expect(Hand.new("2c 4d 5h 4c 5s").two_pair?).to be(true)
      expect(Hand.new("2c 4d 5h 4c Js").two_pair?).to be(false)
    end
  end

  describe "pair?" do
    it "sees if the hand is one pair" do
      expect(Hand.new("2c 4d 5h 4c Js").pair?).to be(true)
      expect(Hand.new("2c 9d Jh 9c Js").pair?).to be(false)
    end
  end

  describe "<=>" do
    it "compares hands based on rank" do
      expect(Hand.new("2c 4d 5h 4c 5s") > Hand.new("2c 4d 5h 4c Js")).to be(true)
      expect(Hand.new("3c 3d Qs Qh 3h") < Hand.new("2c 4d 5h 5c 5s")).to be(false)
      expect(Hand.new("8s 9s Ts Js Qs") == Hand.new("9h 8h Jh Th Qh")).to be(true)
    end
  end
end
