require "spec_helper"

describe Matchup do
  let(:hand1)  { Hand.new("Ad As 3d 2s 5d") }
  let(:hand2)  { Hand.new("Ah 9s Th Ac 3h") }
  let(:hand3)  { Hand.new("6s Jd 3c 4d Kh") }
  let(:hand4)  { Hand.new("Jh Qh 2h 5h 9h") }
  let(:hand5)  { Hand.new("Js Qs 2s 5s 9s") }
  let(:hand6)  { Hand.new("As 3d 4h 2s 5h") }
  let(:hand7)  { Hand.new("4s 5d 7h 6s 8d") }
  let(:hand8)  { Hand.new("3s 5s 6s 8s As") }
  let(:hand9)  { Hand.new("3h 5h 6h Kh Ah") }
  let(:hand10) { Hand.new("3s 3d 3h As Ah") }
  let(:hand11) { Hand.new("4s 2s 4h 2h 4d") }
  let(:hand12) { Hand.new("2s Kh Kd 9c Ks") }
  let(:hand13) { Hand.new("2s Jh Jd Jc Js") }
  let(:hand14) { Hand.new("2s As 3s 4s 5s") }
  let(:hand15) { Hand.new("3c 2c Qs Qh 2s") }
  let(:hand16) { Hand.new("As 5s Th 5h Ts") }
  let(:hand17) { Hand.new("Ac 3s 5d 2c 4s") }
  let(:hand18) { Hand.new("Ac Ks Jc Kc 2d") }
  let(:hand19) { Hand.new("Ad Td Kd Kh 5s") }
  let(:hand20) { Hand.new("9s 9h 9d 5c 9c") }

  describe "#winner" do
    it "returns the better of two hands" do
      expect(Matchup.new(hand1, hand4).winner).to eq(hand4)
      expect(Matchup.new(hand1, hand3).winner).to eq(hand1)
      expect(Matchup.new(hand1, hand2).winner).to eq(hand2)
      expect(Matchup.new(hand6, hand7).winner).to eq(hand7)
      expect(Matchup.new(hand9, hand8).winner).to eq(hand9)
      expect(Matchup.new(hand8, hand6).winner).to eq(hand8)
      expect(Matchup.new(hand10, hand11).winner).to eq(hand11)
      expect(Matchup.new(hand11, hand7).winner).to eq(hand11)
      expect(Matchup.new(hand10, hand12).winner).to eq(hand10)
      expect(Matchup.new(hand13, hand12).winner).to eq(hand13)
      expect(Matchup.new(hand14, hand7).winner).to eq(hand14)
      expect(Matchup.new(hand16, hand15).winner).to eq(hand15)
      expect(Matchup.new(hand3, hand4).winner).to eq(hand4)
      expect(Matchup.new(hand18, hand19).winner).to eq(hand18)
      expect(Matchup.new(hand20, hand14).winner).to eq(hand14)
      expect(Matchup.new(hand20, hand13).winner).to eq(hand13)
    end

    it "returns nil in case of a tie" do
      expect(Matchup.new(hand4, hand5).winner).to be_nil
      expect(Matchup.new(hand17, hand6).winner).to be_nil
    end
  end
end
