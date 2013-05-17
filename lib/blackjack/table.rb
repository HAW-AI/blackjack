class Table
  MINIMUM_BET = 50 #cents
  attr_accessor :cards, :bets

  def initialize(*args)
    @cards = {}
    @bets  = {}
  end

  def player_gets_card(player, card)
    cards[player.name] = card
  end

  def cards_of_player(player)
    cards[player.name]
  end

  def players_bet(player)
    bets[player]
  end

  # returns true if user's bet was within his available money
  def player_bets(player, amount)
    player.withdraw_from_money(amount)
  end

  def cards_of_the_dealer
    cards.select {|player, _| player.dealer? }.values
  end

  # return the dealer's second, covered card
  def dealers_hole_card
    # here we have a chance to return a card that will match the highest hand
    # of the players so we still win against the player.
    # so far i don't know what to do when the dealers first card is a
    # card of low value like a 2 and a player has a hand of the value of i.e. 20
    # we need at least cards of the value of 18 to match the player's hand. This
    # obviously can't be done with a single card.
    suitable_hole_card = nil
    player_gets_card(dealer, suitable_hole_card)
    suitable_hole_card
  end

  # bet is a positive integer of cents
  # Player x PosInteger -> none
  def player_bets(player, bet)
    if bet && bet > 0
      bets[player] = bet
    end
  end

  private

  def dealer
    cards.keys.select {|player| player.dealer? }.first
  end
end
