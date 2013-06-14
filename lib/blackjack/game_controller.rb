class GameController
  attr_reader   :blackjack
  attr_accessor :exit_application

  def initialize(*args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    @blackjack        = Blackjack.new
    @exit_application = false
  end

  def exit_application?
    exit_application
  end

  def handle_user_input(input_string)
    if input_string.nil? || input_string.empty?
      puts "Please enter something."
    elsif input_string == "exit"
      self.exit_application = true
    else
      send "handle_#{blackjack.state.to_s}_input".to_sym, input_string
    end

    print_instructions
  end

  private

  def auto_bet
    unless blackjack.bet(blackjack.table.current_minimum_bet)
      puts "You dont have enough money. Leave the table."
      exit
    end
    #blackjack.in_game
  end

  def handle_pre_game_input(input_string)
    username = input_string
    blackjack.add_player(username)
    blackjack.betting
    puts "User '#{username}' was added to the game"
    puts "Stated a game of blackjack"
    auto_bet
  end

  def handle_betting_input(input_string)
    amount = input_string.to_i
    if blackjack.bet(amount)
      puts "#{blackjack.current_player} bets #{amount} cent"
    end
  end

  def handle_in_game_input(input_string)
    if input_string == "h" || input_string == "hit"
      blackjack.hit
    elsif input_string == "s" || input_string == "stay"
      blackjack.stay
    else
      #
    end
  end

  def handle_raising_the_stakes_input(input_string)
    if input_string == "y"
      blackjack.accept_double_bet
    elsif input_string == "n"
      blackjack.refuse_double_bet
    else

    end
  end

  def handle_end_of_round_input(input_string)
    if input_string == "n" || input_string == "new" || input_string == "new round"
      puts "Starting a new round (#{blackjack.round+1})."
      blackjack.betting
      auto_bet
    else
      #
    end

  end

  def print_instructions
    print "\n"
    if blackjack.state == :pre_game
      puts "Enter the name of the next player like 'somename' or write 'start' to start the game"
      print ">> "
    elsif blackjack.state == :betting
      puts "#{blackjack.current_player}, please bet an amount within your available money of #{blackjack.current_player.money} cents."
      print user_prompt
    elsif blackjack.state == :in_game
      puts "#{blackjack.current_player}, press h for hit or s for stay."
      print user_prompt
    elsif blackjack.state == :raising_the_stakes
      puts "The dealer offers you the chance to double your bet."
      puts "Press 'y' to accept this offer or 'n' to reject."
      print user_prompt
    elsif blackjack.state == :end_of_round
      puts "The round ended. To start a new round press n"
      print ">> "
    else
      #
    end
  end

  def user_prompt
    "#{blackjack.current_player} >> "
  end
end
