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
    breadth_first_search(start_value, target_value)
  end

private

  def cards
    Card::SUITS.map do |suit|
      Card::RANKS.map do |rank|
        Card.new(suit: suit, rank: rank)
      end
    end.flatten
  end

  def path_from_record(record)
    if record[:parent].nil?
      [record[:card]]
    else
      path_from_record(record[:parent]) + [record[:card]]
    end
  end

  def breadth_first_search(start_value, target_value)
    open_list = cards.map { |c| { parent: nil, card: c, sum: start_value + c.value } }

    while not open_list.empty?
      new_open_list = []

      open_list.each do |record|
        if record[:sum] >= target_value && record[:sum] <= 21
          return path_from_record(record)
        elsif record[:sum] < 17 # only allowed to take cards while under 17
          new_cards = cards.map { |c| { parent: record, card: c, sum: record[:sum] + c.value } }
          new_open_list = new_open_list + new_cards
        end
      end

      open_list = new_open_list
    end
  end

end
