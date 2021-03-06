class Bet
  attr_reader :amount

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def to_s
    amount.to_s
  end
end
