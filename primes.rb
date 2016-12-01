#!/usr/bin/env ruby
## primes.rb - simple class for prime number computation

require 'test/unit'

class Prime

  def initialize; end

  def self.prime?(number)
    divisors = Array.new
    number.downto(1).each do |pd|
      divisors << pd if (number % pd).eql?(0)
    end

    divisors.eql?([number, 1])
  end

  def self.left_truncatable_prime?(number)
    string = number.to_s
    return false if string.include?('0')

    results   = Hash.new

    string.length.downto(1) do |round|
      candidate = string[(round - 1)..string.length]
      results[candidate] = self.prime?(candidate.to_i)
    end

    ! results.values.include?(false)
  end

  def self.right_truncatable_prime?(number)
    string = number.to_s
    results = Hash.new
    candidate = ''
    string.each_char do |s|
      candidate << s
      results[candidate] = self.prime?(candidate.to_i)
    end

    ! results.values.include?(false)
  end

end

class TestPrime < Test::Unit::TestCase

  def setup
    @primes = {
        :prime     => [ 439, 761, 73],
        :ltp       => [ 9137, 1223 ],
        :rtp       => [ 7393, 29399, 7331 ],
        :two_sided => [ 373, 797, 3137, 3797, ]
    }
  end

  def teardown; end

  def test_prime
    @primes.keys.collect { |k| @primes[k] }.flatten.each do |p|
      assert(Prime.prime?(p), sprintf('not prime, should be[%s]', p))
    end
  end

  def test_ltp
    @primes[:ltp].each do |p|
      assert(Prime.left_truncatable_prime?(p), sprintf('not ltp, should be[%s]', p))
    end
  end

  def test_rtp
    @primes[:rtp].each do |p|
      assert(Prime.right_truncatable_prime?(p), sprintf('not rtp, should be[%s]', p))
    end
  end

end

