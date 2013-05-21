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

  # be smart
  def draw_cards_that_beat(start_value, target_value)
    cards = []

    begin
      cards << draw_card
    end while (start_value + cards.map(&:value).inject(0, :+) < 17)

    cards

    # if target_value > 11
    #   # if the target_value is higher than 11 we will have to draw again anyway
    #   [draw_card]
    # else
    #   suit = Card::SUITS.sample
    #   if target_value == 11
    #     rank = "A"
    #   elsif target_value == 10
    #     rank = %w(10 J Q K).sample
    #   else
    #     rank = %w{ 2 3 4 5 6 7 8 9 }.sample
    #   end
    #   [Card.new(suit: suit, rank: rank)]
    # end
  end
end
