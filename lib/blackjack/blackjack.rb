class Blackjack
  attr_reader :table, :deck, :dealer, :players, :state

  GAME_STATES = [:pre_game, :in_game, :end_of_round]

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
    if round_finished?
      end_of_round
    else
      next_player
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
    else
      next_player
    end
    puts table.to_s
    nil
  end

  def current_player
    players.current
  end

  def round_finished?
    players.all? {|player| player.finished? }
  end

  def in_game
    if (state == :pre_game || state == :end_of_round) && players.size > 0
      puts "Starting a game of blackjack."
      @state = :in_game
      new_round

      players.each { |p| 2.times { p.receive_card(deck.draw_card) } }
      puts table.to_s

      true
    else
      false
    end
  end

  private

  def next_player
    begin
      players.next
    end until not current_player.finished?

    current_player
  end

  def new_round
    @table = Table.new
    @deck  = Deck.new

    players.reset

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
