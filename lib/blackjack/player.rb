class Player
  attr_reader :name, :id, :hand, :table

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @table    = nil
    @finished = false
    @id       = SecureRandom.random_number(1000000000)
    @hand     = Hand.new
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  def receive_card(card)
    hand << card
    finish if hand.value >= 21
  end

  def dealer?
    false
  end

  def has_won?
    false
  end

  def new_round
    hand.clear
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
