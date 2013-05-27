class Dealer < Player
  def initialize(*args)
    super(args)
    @name  = "Dealer"
  end

  def dealer?
    true
  end

  # return the dealer's second, covered card
  def hole_card
    # here we have a chance to return a card that will match the highest hand
    # of the players so we still win against the player.
    # so far i don't know what to do when the dealers first card is a
    # card of low value like a 2 and a player has a hand of the value of i.e. 20
    # we need at least cards of the value of 18 to match the player's hand. This
    # obviously can't be done with a single card.
    suitable_hole_card = deck.draw_card_that_beats(table.highest_non_bust_hand_value)
    receive_card(suitable_hole_card)
    suitable_hole_card
  end

  def has_won?
    hand.value == table.highest_non_bust_hand_value
  end
end
