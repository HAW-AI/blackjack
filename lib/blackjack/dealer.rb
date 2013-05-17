class Dealer < Player
  POSITIVE_INFINITY = +1.0/0.0

  def initialize(*args)
    super(args)
    @money = POSITIVE_INFINITY
    @name  = "Dealer"
  end

  def dealer?
    true
  end
end
