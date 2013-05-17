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

  def to_s
    "#{@suit} - #{@rank}"
  end

  # FIXME not correct yet. 10 and facecards are equal in value and an ace
  #       is worth 11
  def <=>(other)
    rank <=> other.rank
  end
end
