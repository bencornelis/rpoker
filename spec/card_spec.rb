require "spec_helper"

describe Card do

  it "has an upcase value and downcase suit" do
    card = Card.new("Js")

    expect(card.value).to eq("J")
    expect(card.suit).to eq("s")
  end

  describe "#to_s" do
    it "prints the value and suit" do
      expect(Card.new("Tc").to_s).to eq("Tc")
    end
  end

  describe "#face_card?" do
    it "is true for a face card" do
      expect(Card.new("Js").face_card?).to be(true)
    end

    it "is false otherwise" do
      expect(Card.new("5d").face_card?).to be(false)
    end
  end

  describe "#num_value" do
    it "returns the value of a card" do
      expect(Card.new("9h").num_value).to eq(9)
    end

    it "converts a face card to a numeric value" do
      expect(Card.new("Kd").num_value).to eq(13)
    end
  end
end
