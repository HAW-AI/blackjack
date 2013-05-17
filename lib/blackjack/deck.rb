class Deck
  attr_reader :cards

  def initialize(*args)
    @cards = []
    Card::SUITS.cycle(1) do |suit|
      Card::RANKS.cycle(1) do |rank|
        @cards << Card.new(suit: suit, rank: rank)
      end
    end

    @cards.shuffle!
  end

  # Returns a random card
  def draw_card
    suit = Card::SUITS.sample
    rank = Card::RANKS.sample
    Card.new(suit: suit, rank: rank)
  end
end
