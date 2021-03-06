require "spec_helper"
require "pry"

# 8 stands for straight flush and 9 royal flush; we classify both these as straight flush
RANKS = [:straight_flush, *Hand::RANKS, :high_card].reverse
RANK_MAPPING = Hash[(0..9).zip(RANKS)]
SUITS = Hash[(1..4).zip(%w(h s d c))]

def errors_against_million_hands
  # This comes from https://archive.ics.uci.edu/ml/datasets/Poker+Hand

  data_file = File.expand_path(File.dirname(__FILE__) + "/../fixtures/poker-hand-testing.data")

  if File.exist?(data_file)
    puts "Starting integration test....this could take a while"
  else
    warn "*"*80
    warn "Could not find #{data_file}"
    warn "Please see README for instructions running integration tests"
    warn "*"*80
    exit(1)
  end

  errors = 0
  File.new(data_file).each do |line|
    columns = line.split(',')

    expected_rank = RANKS[columns.delete_at(10).to_i]

    cards = []
    columns.each_slice(2) do |suit, value|
      rp_suit = SUITS[suit.to_i]
      rp_num_value = (value.to_i == 1 ? 14 : value.to_i)

      rp_value =
        if rp_num_value >= 10
          Card::FACE_TO_NUM.invert[rp_num_value]
        else
          rp_num_value
       end

      cards << Card.new("#{rp_value}#{rp_suit}")
    end

    hand = Hand.new(cards)

    if hand.rank != expected_rank
      puts "\nInconsistency found in: #{line}"
      errors += 1
    end
  end
  errors
end

describe "ranking hands" do
  it "is accurate when checking against a million hand dataset" do
    expect(
      errors_against_million_hands
    ).to be 0
  end
end
