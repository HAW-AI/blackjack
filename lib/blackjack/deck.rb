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

  def draw_cards_that_beat_with_a_star(start_value, target_value)
    a_star(start_value, target_value)
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

  # tutorial from http://www.policyalmanac.org/games/aStarTutorial.htm
  def a_star(start_value, target_value)
    highest_card_value = cards.map(&:value).max
    h = lambda { |v| ((target_value - v) / highest_card_value).ceil }

    open_list = cards.map do |card|
      sum = start_value + card.value
      h_value = h.call(sum)
      { parent: nil, card: card, sum: sum, f: h_value + 1, g: 1, h: h_value }
    end

    closed_list = []
    path = []

    until open_list.empty? || !path.empty?
      record = open_list.min_by { |r| r[:f] }
      open_list = open_list - [record]
      closed_list = closed_list + [record[:sum]]

      if record[:sum] == target_value
        path = path_from_record(record)
      elsif record[:sum] < 17 # only allowed to take cards while under 17
        cards.select do |card| # only walkable nodes
          sum = record[:sum] + card.value
          sum <= 21 && !closed_list.include?(sum)
        end.each do |card|
          sum = record[:sum] + card.value

          existing_record = open_list.find { |r| r[:sum] == sum }

          g_value = record[:g] + 1
          h_value = h.call(sum)
          f_value = g_value + h_value

          new_record = { parent: record, card: card, sum: sum, f: f_value, g: g_value, h: h_value }

          if existing_record.nil?
            open_list = open_list + [new_record]
          elsif g_value < existing_record[:g]
            existing_record.merge!(new_record)
          end
        end
      end

    end

    path
  end

end
