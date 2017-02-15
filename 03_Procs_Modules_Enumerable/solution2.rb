class Integer
  def is_prime?
    return false if self <= 1

    2.upto(Math.sqrt(self).to_i).each do |n|
      return false if self % n == 0
    end

    true
  end
end

class RationalSequence
  include Enumerable

  def initialize(length = nil)
    @length = length
  end

  def each
    number_components, length = {increasing: 1, decreasing:1, is_increasing: true}, @length

    while length > 0
      if number_components[:is_increasing]
        yield Rational(number_components[:increasing], number_components[:decreasing])
      else
        yield Rational(number_components[:decreasing], number_components[:increasing])
      end

      number_components = get_next(number_components)
      length -= 1
    end
  end

  def to_a
    enum_for(:each).to_a
  end

  private

  def has_common_divisor?(a, b)
    a.gcd(b) != 1
  end

  def get_next(number)
    if number[:decreasing] == 1
      number[:increasing] +=1
      number[:increasing], number[:decreasing] = number[:decreasing], number[:increasing]
      number[:is_increasing] = !number[:is_increasing]
    else
      number[:increasing] += 1
      number[:decreasing] -= 1
    end

    has_common_divisor?(number[:increasing], number[:decreasing]) ? get_next(number) : number
  end
end

class PrimeSequence
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    counter, number = 0, 2
    while counter < @length
      if number.is_prime?
        yield number
        counter += 1
      end

      number += 1
    end
  end

  def to_a
    enum_for(:each).to_a
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    first, second, counter = @first, @second, 0

    while counter < @limit
      yield first
      second, first = second + first, second
      counter += 1
    end
  end

  def to_a
    enum_for(:each).to_a
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    sequence = RationalSequence.new(n)
    primes_product, non_primes_product = 1, 1

    sequence.each do |n|
      has_prime = (n.numerator.is_prime? or n.denominator.is_prime?)
      if has_prime
        primes_product *= n
      else
        non_primes_product *= n
      end
    end

    primes_product / non_primes_product
  end

  def aimless(n)
    sequence, sum = PrimeSequence.new(n), 0
    sequence.each_slice(2) do |slice|
      numerator, denominator = slice[0], slice[1] || 1
      sum += Rational(numerator, denominator)
    end
    sum
  end

  def worthless(n)
    sum_limit, current_sum, numbers = FibonacciSequence.new(n).to_a.last, 0, []
    seq = n > 0 ? RationalSequence.new(Float::INFINITY).to_enum(:each).lazy : []
    seq.each do |n|
      current_sum += n
      return numbers if current_sum > sum_limit
      numbers << n
    end
  end
end
seq = RationalSequence.new(6)
p  seq.to_a
# p 6.is_prime?

# p DrunkenMathematician.worthless(5)s