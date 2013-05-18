class Table
  MINIMUM_BET = 50 #cents
  attr_accessor :cards, :bets

  def initialize(*args)
    @cards = {}
    @bets  = {}
  end

  def player_gets_card(player, card)
    cards[player] = cards_of_player(player) << card
    if value_of_players_cards(player) >= 21
      player.finish
    end
  end

  def cards_of_player(player)
    cards[player] || []
  end

  def players_bet(player)
    bets[player]
  end

  def value_of_players_cards(player)
    cards[player].inject(0) {|sum, card| sum + card.value }
  end

  # amount is a positive integer of cents
  # returns true if user's bet was within his available money
  def player_bets(player, amount)
    if amount && amount > 0
      bets[player] = amount
      player.withdraw_from_money(amount)
    end
  end

  def cards_of_the_dealer
    cards_of_player(dealer)
  end

  # returns an integer
  def highest_card_combo_value
    players.map {|player| value_of_players_cards(player)}.select {|value| value <= 21}.max
  end

  # return the dealer's second, covered card
  def dealers_hole_card
    # here we have a chance to return a card that will match the highest hand
    # of the players so we still win against the player.
    # so far i don't know what to do when the dealers first card is a
    # card of low value like a 2 and a player has a hand of the value of i.e. 20
    # we need at least cards of the value of 18 to match the player's hand. This
    # obviously can't be done with a single card.
    suitable_hole_card = draw_card_that_beats(highest_card_combo_value)
    player_gets_card(dealer, suitable_hole_card)
    suitable_hole_card
  end

  def dealer_has_won?
    players.map {|p| hand_busts?(p) }.all? ||
      value_of_players_cards(dealer) > players.map {|p| value_of_players_cards(p)}.max
  end

  def hand_busts?(player)
    value_of_players_cards(player) > 21
  end

  def blackjack?(player)
    value_of_players_cards(player) == 21
  end

  def to_s
    result = ""

    cards.each do |player, cards|
      puts player.to_s + ":"
      cards.each do |card|
        result += "  " + card.to_s + "\n"
      end
      result += "  Total Value: #{value_of_players_cards(player)}"
    end


    result
  end

  private

  def players
    bets.keys
  end

  def dealer
    cards.keys.select {|player| player.dealer? }.first
  end
end
