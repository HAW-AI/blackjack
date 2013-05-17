class UI
  attr_reader :game_controller

  def initialize(*args)
    @game_controller = GameController.new
  end

  def run
    puts "Welcome to the blackjack table!"
    puts "Enter the name of the player like 'player: somename'"
    print ">> "

    loop do
      input = gets.chomp.strip.downcase
      game_controller.handle_user_input(input)

      if game_controller.exit_application?
        break
      end
    end

    puts "Thanks for playing blackjack. Come again."
  end
end
