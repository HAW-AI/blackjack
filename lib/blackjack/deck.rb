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
      { parent: nil, card: card, sum: start_value + card.value, f: 0, g: 0, h: 0 }
    end

    # no closed list, because we can only move 'forward' (no negative card values)
    closed_list = []

    while not open_list.empty?
      record = open_list.first
      open_list = open_list.drop(1)
      closed_list << record

      if record[:sum] >= target_value && record[:sum] <= 21
        return path_from_record(record)
      elsif record[:sum] < 17 # only allowed to take cards while under 17
        cards.select do |card| # only walkable nodes
          sum = record[:sum] + card.value
          sum <= 21 && (not closed_list.include?(sum))
        end.each do |card|
          existing_index = open_list.index { |r| r[:sum] == record[:sum] + card.value }
          existing_record = if existing_index.nil? then nil else open_list[existing_index] end

          g_value = record[:g] + 1
          h_value = h.call(card.value)
          f_value = g_value + h_value

          if existing_record.nil?
            new_record = {
              parent: record,
              card: card,
              sum: record[:sum] + card.value,
              f: f_value,
              g: g_value,
              h: h_value
            }

            open_list << new_record
          elsif g_value < existing_record[:g]
            existing_record[:parent] = record
            existing_record[:card] = card
            existing_record[:f] = f_value
            existing_record[:g] = g_value
            existing_record[:h] = h_value
          end
        end
      end

      open_list.sort_by! { |r| r[:f] }
    end

    []
  end

end
