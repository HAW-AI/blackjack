# taken from: https://gist.github.com/sausheong/2533435#file-circularlist-rb
class CircularList < Array
  def index
    @index ||=0
    @index.abs
  end

  def current
    @index ||= 0
    get_at(@index)
  end

  def next(num=1)
    @index ||= 0
    @index += num
    get_at(@index)
  end

  def previous(num=1)
    @index ||= 0
    @index -= num
    get_at(@index)
  end

  def reset
    @index = 0
  end

  private

  def get_at(index)
    if index >= 0
      at(index % self.size)
    else
      index = self.size + index
      get_at(index)
    end
  end
end
