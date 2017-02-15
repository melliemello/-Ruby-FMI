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
    length, n = 0, 1

    while length < @length
      number = get_rational(n)
      if number != nil
        yield number
        length += 1
      end

      n += 1
    end
  end

  private

  def has_common_divisor?(a, b)
    a.gcd(b) != 1
  end

  def get_rational(n)
    diagonals_to_skip = ((-1 + Math.sqrt(1 + 8 * n)) / 2).floor
    step = n - diagonals_to_skip * (diagonals_to_skip + 1) / 2 #2
    first = step <= 1 ? diagonals_to_skip + step : diagonals_to_skip + 2 - step
    second = step <= 1 ? 1 : step

    number = diagonals_to_skip % 2 == 0 ?  Rational(second, first) : Rational(first, second)
    has_common_divisor?(first, second) ? nil : number
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
    seq = n > 0 ? RationalSequence.new(Float::INFINITY).lazy : []
    seq.each do |x|
      current_sum += x
      return numbers if current_sum > sum_limit
      numbers << x
    end
  end
end

a = RationalSequence.new(0).lazy
p a.to_a