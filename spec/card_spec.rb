require "spec_helper"

describe Card do

  it "has an upcase value and downcase suit" do
    card = Card.new("Js")

    expect(card.value).to eq("J")
    expect(card.suit).to eq("s")
  end

  it "raises an error if the input has more than two characters" do
    expect {
      Card.new("Jsc")
    }.to raise_error(ArgumentError, "Wrong number of characters")
  end

  it "validates input" do
    expect {
      Card.new("Yc")
    }.to raise_error(ArgumentError, "Input must start with a value")

    expect {
      Card.new("Jm")
    }.to raise_error(ArgumentError, "Input must end with a suit")
  end

  describe "#to_s" do
    it "prints the value and suit" do
      expect(Card.new("Tc").to_s).to eq("Tc")
    end
  end

  describe "#face?" do
    it "is true for a face card" do
      expect(Card.new("Js").face?).to be(true)
    end

    it "is false otherwise" do
      expect(Card.new("5d").face?).to be(false)
    end
  end

  describe "#to_i" do
    it "returns the integer value of a card" do
      expect(Card.new("9h").to_i).to eq(9)
    end

    it "converts a face card to an integer" do
      expect(Card.new("Kd").to_i).to eq(13)
    end
  end
end
