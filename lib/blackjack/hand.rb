class Hand
  attr_reader :cards

  def initialize(*args)
    @cards = []
  end

  def <<(card)
    return unless card.is_a?(Card)
    @cards << card
  end

  def clear
    @cards = []
  end

  def value
    if cards.length == 2 && cards.all? { |c| c.rank == "A" } # two aces
      21
    else
      cards.inject(0) {|sum, card| sum + card.value }
    end
  end

  def bust?
    value > 21
  end

  def blackjack?
    value == 21
  end

  def to_s
    result = ""
    cards.each {|card| result += "  " + card.to_s + "\n" }
    result += "  Total: " + value.to_s + "\n"
    result
  end
end
