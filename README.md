### rpoker

A ruby library for comparing and ranking poker hands.

### Install

```
gem install rpoker
```

### Comparing hands

```ruby
hand1 = Hand.new("Ac Qh Jd Jh Qs")
hand2 = Hand.new(["2s", "3s", "5s", "4s", "As"])

hand1 < hand2
# => true
```

### Ranking hands

```ruby
hand1.rank
# => :two_pair
hand2.rank
# => :straight_flush
```
### Specs

To run rspec specs:
```
rake
```

To run a more comprehensive test for the ranking of over a million hands, first download the dataset using:

```
wget -P ./spec/fixtures http://archive.ics.uci.edu/ml/machine-learning-databases/poker/poker-hand-testing.data
```

Then run:
```
rake integration
````
