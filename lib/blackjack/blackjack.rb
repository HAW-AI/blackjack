class Blackjack
  attr_reader :table, :deck, :dealer

  def initialize(*args)
    @dealer       = Dealer.new(name: "Dealer")
    @players      = CircularList.new
    @players      << @dealer
    new_round
  end

  def add_player(user)
    @players << user
  end

  def hit
    # user takes a card
    new_card = deck.draw_card
    table.user_gets_card(current_player, new_card)
    next_player
    new_card
  end

  def stay
    # user doesnt take another card
    current_player.finished
    next_player
  end

  def current_player
    @players.current
  end

  def cards_of_user(user)
    # return an array of the cards a player/dealer has gotten so far
    table.cards_of_user(user)
  end

  def round_finished?
    @players.all? {|player| player.finished?}
  end

  private

  def next_player
    @players.next
  end

  def new_round
    @table = Table.new
    @deck  = Deck.new
  end
end
