#!/usr/bin/env ruby
## circular_array.rb is a POC abstraction of a.. circular array class

require 'test/unit'

class CircularArray

  attr_reader :array, :index

  def initialize(array)
    @array = array
    @index = 0
  end

  def to_s
    self.inspect.to_s # get the current value
  end

  # use this to get the actual value, necessary if contents are not already strings
  def inspect
    @array[@index]
  end

  def next
    @array[@index + 1]
  end

  def next!
    @index += 1
    @array[@index]
  end

  def last
    @array[@index - 1]
  end

  def last!
    @index -= 1
    @array[@index]
  end

end

class TestCircularArray < Test::Unit::TestCase

  def setup

    @arrays = [
      (1..5).to_a,
      ('a'..'n').to_a,
      ('a'..'z').to_a,
      (1..10).to_a,
    ]

  end

  def test_happy_path
    @arrays.each do |a|
      o = CircularArray.new(a)

      original_o = o.inspect
      position   = a.index(original_o)

      assert_not_equal(o, o.next)
      assert_not_equal(o, o.last)

      assert_equal(o.next, a[position + 1])
      assert_equal(o.last, a[position - 1])

      assert_equal(o.inspect, original_o)

    end
  end

  def test_happy_path_in_place
    @arrays.each do |a|
      o = CircularArray.new(a)



    end
  end
end
