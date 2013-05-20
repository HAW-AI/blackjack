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
    blackjack.bet(50)
  end

  def handle_pre_game_input(input_string)
    if input_string == "start"
      if blackjack.betting
        puts "Starting a game of blackjack."
        auto_bet
      else
        puts "Cannot start a game without any players."
      end
    else
      username = input_string
      blackjack.add_player(username)
      puts "User '#{username}' was added to the game"
    end
  end

  def handle_betting_input(input_string)
    amount = input_string.to_i
    if blackjack.bet(amount)
      puts "#{blackjack.current_player} bets #{amount} cents"
    end
  end

  def handle_in_game_input(input_string)
    if input_string == "h" || input_string == "hit"
      blackjack.hit
      puts round_results if blackjack.round_finished?
    elsif input_string == "s" || input_string == "stay"
      blackjack.stay
      puts round_results if blackjack.round_finished?
    else
      #
    end
  end

  def handle_end_of_round_input(input_string)
    if input_string == "n" || input_string == "new" || input_string == "new round"
      puts "Starting a new round."
      blackjack.betting
      auto_bet
    else
      #
    end

  end

  def round_results
    "foobar"
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
