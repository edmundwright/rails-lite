module Arrayable
  def [](index)
    to_a[index]
  end

  def length
    to_a.length
  end

  def first
    self[0]
  end

  def last
    self[-1]
  end

  def ==(other_thing)
    if other_thing.class == Array
      to_a == other_thing
    else
      super(other_thing)
    end
  end

  def each(&prc)
    to_a.each(&prc)
  end
end
