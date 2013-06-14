class Table
  attr_reader :players, :dealer, :current_minimum_bet

  def initialize(minimum_bet = 50)
    @dealer  = nil
    @players = []
    @current_minimum_bet = minimum_bet
  end

  def players_and_dealer
    @players + [@dealer]
  end

  def raise_minimum_bet
    @current_minimum_bet = @current_minimum_bet * 2
    puts "The minimum bet has been raised to #{@current_minimum_bet}"
  end

  # returns an integer or nil if non exists
  def highest_non_bust_hand_value
    hands.select {|hand| !hand.bust? }.map {|hand| hand.value }.max
  end

  def to_s
    result = ""
    players_and_dealer.each do |player|
      result += player.to_s
      result += player.hand.to_s
    end
    result
  end

  def add_player(player)
    return unless player.is_a?(Player)
    @players << player
    player.table = self
  end

  def dealer=(dealer)
    return unless dealer.is_a?(Dealer) && @dealer.nil?
    @dealer = dealer
    dealer.table = self
  end

  def hands
    players_and_dealer.map {|player| player.hand }
  end
end
