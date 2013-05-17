class Blackjack
  attr_reader :table, :deck, :dealer, :players, :state

  GAME_STATES = [:pre_game, :betting, :in_game, :end_of_round]

  def initialize(*args)
    @dealer       = Dealer.new
    @players      = CircularList.new
    @state        = :pre_game
  end

  def add_player(username)
    return false unless state == :pre_game

    @players << Player.new(name: username)
  end

  # user takes a card
  def hit
    return false unless state == :in_game

    new_card = deck.draw_card
    table.user_gets_card(current_player, new_card)
    next_player
    if round_finished?
      end_of_round
    end
    new_card
    nil
  end

  # user doesnt take another card
  def stay
    return false unless state == :in_game

    current_player.finished?
    if round_finished?
      end_of_round
    end
    next_player
    nil
  end

  def bet(amount)
    return false unless state == :betting

    result = table.player_bets(current_player, amount)
    if result
      next_player
      if all_bets_are_in?
        in_game
      end
      result
    else
      result
    end
  end

  def current_player
    players.current
  end

  def cards_of_user(user)
    # return an array of the cards a player/dealer has gotten so far
    table.cards_of_user(user)
  end

  def round_finished?
    players.all? {|player| player.finished?}
  end

  def all_bets_are_in?
    table.bets.keys.size == players.size
  end

  def betting
    if state == :in_game || state == :pre_game || state == :end_of_round
      @state = :betting
      new_round
      true
    else
      false
    end
  end

  private

  def next_player
    players.next
  end

  def new_round
    @table = Table.new
    @deck  = Deck.new
  end

  ### Handling of game states

  def pre_game
    if state == :end_of_round
      @state = :pre_game
      true
    else
      false
    end
  end

  def in_game
    if state == :betting
      @state = :in_game
      true
    else
      false
    end
  end

  def end_of_round
    if state == :in_game
      @state = :end_of_round
      true
    else
      false
    end
  end
end
