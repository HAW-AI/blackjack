class Player
  attr_reader :name, :money

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @finished  = false
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  def dealer?
    false
  end
end
