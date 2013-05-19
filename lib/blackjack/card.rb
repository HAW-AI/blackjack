class Card
  include Comparable

  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = %w{ 2 3 4 5 6 7 8 9 10 J Q K A}

  attr_reader :suit, :rank

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def value
    if rank.to_i > 0
      rank.to_i
    else
      rank == "A" ? 11 : 10
    end
  end

  def to_s
    "#{@suit} - #{@rank}"
  end

  def <=>(other)
    value <=> other.value
  end
end
