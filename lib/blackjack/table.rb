class Table
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

  # bet is a positive integer of cents
  # Player x PosInteger -> none
  def player_bets(player, bet)
    if bet && bet > 0
      bets[player] = bet
    end
  end
end
