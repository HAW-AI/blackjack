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
    current_player.receive_card(new_card)
    next_player
    if round_finished?
      end_of_round
    end
    puts table.to_s
    new_card
  end

  # user doesnt take another card
  def stay
    return false unless state == :in_game

    current_player.finish
    if round_finished?
      end_of_round
    end
    puts table.to_s
    next_player
    nil
  end

  def bet(amount)
    return false unless state == :betting

    if current_player.bets(amount)
      next_player
      if all_bets_are_in?
        in_game
      end
      true
    else
      false
    end
  end

  def current_player
    players.current
  end

  def round_finished?
    players.all? {|player| player.finished? }
  end

  def all_bets_are_in?
    players.all? {|player| player.placed_a_bet? }
  end

  def betting
    if (state == :in_game || state == :pre_game || state == :end_of_round) &&
       players.size > 0
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

    players.each do |player|
      player.new_round
      @table.add_player(player)
    end
    dealer.new_round
    table.dealer = dealer
    dealer.receive_card(deck.draw_card)
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
      # award some money to those that won. just the dealer basically
      dealer_draws_cards

      print_results
      true
    else
      false
    end
  end

  # At the end of a round a dealer draws cards to bet against what's
  # already on the table
  def dealer_draws_cards
    initial_value = dealer.hand.cards.first.value
    highest_value = table.highest_non_bust_hand_value
    cards = deck.draw_cards_that_beat(initial_value, highest_value)

    cards.each { |c| dealer.receive_card(c) }
  end

  def print_results
    if dealer.hand.blackjack?
      puts "The dealer wins with a blackjack."
    elsif dealer.has_won?
      puts "The dealer wins with a hand value of #{dealer.hand.value}."
    else
      puts "Some user beat the house. WTF?!"
    end
  end
end
