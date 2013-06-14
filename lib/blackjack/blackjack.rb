class Blackjack
  attr_reader :table, :deck, :dealer, :players, :state, :round

  GAME_STATES = [:pre_game, :betting, :in_game, :end_of_round]
  NUMBER_OF_GAME_ROUNDS = 15

  def initialize(*args)
    @dealer       = Dealer.new
    @players      = CircularList.new
    @state        = :pre_game
    @round        = 0
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
      raising_the_stakes
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
      raising_the_stakes
    else
      next_player
    end
    puts table.to_s
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

  def accept_double_bet
    current_player.bet = Bet.new(amount: current_player.bet.amount * 2)
    end_of_round
  end

  def refuse_double_bet
    end_of_round
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
    begin
      players.next
    end until not current_player.finished?

    current_player
  end

  def new_round
    if @round == 0
      @table = Table.new
    else
      @table = Table.new(@table.current_minimum_bet)
    end
    @deck  = Deck.new
    @round += 1

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

  def in_game
    if state == :betting
      @state = :in_game

      players.each { |p| 2.times { p.receive_card(deck.draw_card) } }
      puts table.to_s

      true
    else
      false
    end
  end

  def raising_the_stakes
    if state == :in_game && !dealer.has_won? && dealer.hand.value >= 9 && !current_player.hand.blackjack?
      @state = :raising_the_stakes
      true
    else
      end_of_round
    end
  end

  def end_of_round
    if state == :in_game || state == :raising_the_stakes
      @state = :end_of_round
      # award some money to those that won. just the dealer basically
      dealer_draws_cards unless dealer.has_won?

      if players.first.has_won?
        players.first.wins
      end

      print_results

      if @round >= NUMBER_OF_GAME_ROUNDS - 1
        puts "You played for #{NUMBER_OF_GAME_ROUNDS} rounds."
        puts "finished game. bye."
        exit
      else
        table.raise_minimum_bet if players.first.has_won?
      end
      true
    else
      false
    end
  end

  # At the end of a round a dealer draws cards to bet against what's
  # already on the table
  def dealer_draws_cards
    until dealer.hand.value >= 17
      dealer.receive_card(deck.draw_card)
    end
    puts table.to_s
  end

  def print_results
    if dealer.hand.blackjack?
      puts "The dealer wins the round with a blackjack."
    elsif dealer.has_won?
      puts "The dealer wins the round with a hand value of #{dealer.hand.value}."
    else
      puts "#{players.first.name} wins the round."
    end
    puts "#{players.first.name} has #{players.first.money} cent left."
  end
end
