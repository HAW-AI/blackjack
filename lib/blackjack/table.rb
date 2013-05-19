class Table
  MINIMUM_BET = 50 #cents
  attr_reader :players

  def initialize(*args)
    @dealer  = nil
    @players = []
  end

  # returns an integer or nil if non exists
  def highest_non_bust_hand_value
    hands.select {|hand| !hand.bust? }.map {|hand| hand.value }.max
  end

  def to_s
    result = ""
    players.each do |player|
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
    players.map {|player| player.hand }
  end
end
