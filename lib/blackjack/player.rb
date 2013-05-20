class Player
  attr_reader :name, :id, :hand, :money, :bet, :table

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @table    = nil
    @finished = false
    @money    ||= 5000
    @id       = SecureRandom.random_number(1000000000)
    @hand     = Hand.new
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  # returns true if money was withdrawn
  def withdraw_from_money(amount)
    amount = amount.abs
    if amount >= Table::MINIMUM_BET && (money - amount) >= 0
      @money = money - amount
      true
    else
      puts "The minimum bet at this table is #{Table::MINIMUM_BET}."
      false
    end
  end

  # not really needed since the player will never win any money :)
  def add_to_money(amount)
    puts "winner winner, chicken dinner!"
    puts "the player #{name} just won #{amount} with the hand #{hand}"
    puts "this should not happen"
  end

  def receive_card(card)
    hand << card
    finish if hand.value >= 21
  end

  def bets(amount)
    if amount && amount.to_i.abs.between?(Table::MINIMUM_BET, money)
      @bet = Bet.new(amount: amount.abs)
      withdraw_from_money(amount)
      true
    else
      false
    end
  end

  def dealer?
    false
  end

  def has_won?
    false
  end

  def placed_a_bet?
    !!bet
  end

  def new_round
    hand.clear
    @bet = nil
    @finished = false
  end

  def to_s
    name.to_s
  end

  def hash
    id
  end

  def table=(new_table)
    return unless new_table.is_a?(Table) && @table.nil?
    @table = new_table
  end
end
