require "spec_helper"

describe Matchup do
  let(:hand1) { Hand.new("Ad As 3d 2s 5d") }
  let(:hand2) { Hand.new("Ah 9s Th Ac 3h") }
  let(:hand3) { Hand.new("6s Jd 3c 4d Kh") }
  let(:hand4) { Hand.new("Jh Qh 2h 5h 9h") }
  let(:hand5) { Hand.new("Js Qs 2s 5s 9s") }

  describe "#winner" do
    it "returns the better of two hands" do
      expect(Matchup.new(hand1, hand4).winner).to eq(hand4)
      expect(Matchup.new(hand1, hand3).winner).to eq(hand1)
      expect(Matchup.new(hand1, hand2).winner).to eq(hand2)
    end

    it "returns nil in case of a tie" do
      expect(Matchup.new(hand4, hand5).winner).to be_nil
    end
  end
end