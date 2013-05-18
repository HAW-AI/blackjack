class Player
  attr_reader   :name, :id
  attr_accessor :money

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @finished = false
    @money    ||= 5000
    @id       = SecureRandom.random_number(1000000000)
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
      self.money = money - amount
      true
    else
      puts "The minimum bet at this table is #{Table::MINIMUM_BET}."
      false
    end
  end

  # not really needed since the player will never win any money :)
  def add_to_money(amount)
    puts "winner winner, chicken dinner"
  end

  def dealer?
    false
  end

  def to_s
    name.to_s
  end

  def hash
    id
  end
end
