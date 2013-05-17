class GameController
  attr_reader   :blackjack
  attr_accessor :exit_application

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def exit_application?
    exit_application
  end

  def handle_user_input(input_string)
    if input_string.nil? || input_string.empty?
      puts "Please enter something."
    elsif input_string == "exit"
      exit_application = true
    elsif blackjack.state == :pre_game
      handle_pre_game_input(input_string)
    elsif blackjack.state == :betting
      handle_betting_input(input_string)
    elsif blackjack.state == :in_game
      handle_in_game_input(input_string)
    elsif blackjack.state == :end_of_round
      handle_end_of_round_input(input_string)
    else
      handle_post_game_input(input_string)
    end

    print_instructions
  end

  private

  def handle_pre_game_input(input_string)
    if input_string.include?("player:")
      username = input_string.split(":")[1].chomp.strip
      blackjack.add_player(username)
      puts "User '#{username}' was added to the game"
    elsif input_string.include?("start")
      puts "Starting a game of blackjack."
      blackjack.betting
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
    else
      #
    end

  end

  def handle_post_game_input(input_string)
    
  end

  def round_results
    "foobar"
  end

  def print_instructions
    if blackjack.state == :pre_game
      puts "Enter the name of the next player like 'player: somename' or write 'start' to start the game"
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

    end

  end

  def user_prompt
    "#{blackjack.current_player}>> "
  end
end
