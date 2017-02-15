describe 'Third task' do
  describe RationalSequence do
    it 'can calculate the first rational number' do
      expect(RationalSequence.new(1).to_a).to eq ['1/1'.to_r]
    end

    it 'can calculate the first 17 rational numbers' do
      expect(RationalSequence.new(19).to_a).to eq ['1/1', '2/1', '1/2', '1/3', '3/1', '4/1', '3/2', '2/3', '1/4', '1/5', '5/1', '6/1', '5/2', '4/3', '3/4', '2/5', '1/6', '1/7', '3/5'].map(&:to_r)
    end

    it 'can calculate with 0' do
      expect(RationalSequence.new(0).to_a).to eq []
    end

    it 'map returns [] when initialized with 0 length' do
      expect(RationalSequence.new(0).map { |x| x }).to eq []
    end
  end

  describe FibonacciSequence do
    it 'can calculate the first Fibonacci number' do
      expect(FibonacciSequence.new(1).to_a).to eq [1]
    end

    it 'can calculate the first 5 Fibonacci numbers' do
      expect(FibonacciSequence.new(5).to_a).to eq [1, 1, 2, 3, 5]
    end

    it 'can calculate the first 5 Fibonacci numbers, starting from 0' do
      expect(FibonacciSequence.new(5, first:0, second:1).to_a).to eq [0, 1, 1, 2, 3]
    end

    it 'can calculate the first 6 Fibonacci numbers, starting from 13' do
      expect(FibonacciSequence.new(6, first:13, second:21).to_a).to eq [13, 21, 34, 55, 89, 144]
    end

    it 'can calculate with 0' do
      expect(RationalSequence.new(0).to_a).to eq []
    end

    it 'map returns [] when initialized with 0 length' do
      expect(RationalSequence.new(0).map { |x| x }).to eq []
    end
  end

  describe PrimeSequence do
    it 'can calculate the first prime (and it is not Optimus)' do
      expect(PrimeSequence.new(1).to_a).to eq [2]
    end

    it 'can calculate the first 5 primes' do
      expect(PrimeSequence.new(5).to_a).to eq [2, 3, 5, 7, 11]
    end

    it 'can calculate with 0' do
      expect(RationalSequence.new(0).to_a).to eq []
    end

    it 'map returns [] when initialized with 0 length' do
      expect(RationalSequence.new(0).map { |x| x }).to eq []
    end
  end

  describe DrunkenMathematician do
    it 'is drunk' do
      expect(->_{_%_}["->_{_%%_}[%p]"]).to eq '->_{_%_}["->_{_%%_}[%p]"]'
    end

    describe '#meaningless' do
      it 'can calculate for 1' do
        expect(DrunkenMathematician.meaningless(1)).to eq Rational(1, 1)
      end

      it 'can calculate first 6 numbers' do
        expect(DrunkenMathematician.meaningless(6)).to eq Rational(1,4)
      end

      it 'can calculate 0 length seqence' do
        expect(DrunkenMathematician.meaningless(0)).to eq 1
      end
    end

    describe '#aimless' do
      it 'can calculate for 2' do
        expect(DrunkenMathematician.aimless(2)).to eq '2/3'.to_r
      end

      it 'can calculate for 6' do
        expect(DrunkenMathematician.aimless(4)).to eq '29/21'.to_r
      end

      it 'can calculate 0 length seqence' do
        expect(DrunkenMathematician.aimless(0)).to eq 0
      end

      it 'can calculate for 5' do
        expect(DrunkenMathematician.aimless(5)).to eq Rational(260, 21)
      end
    end

    describe '#worthless' do
      it 'can calculate for 1' do
        expect(DrunkenMathematician.worthless(1)).to eq %w(1/1).map(&:to_r)
      end

      it 'can calculate for 5' do
        expect(DrunkenMathematician.worthless(5)).to eq ['1/1', '2/1', '1/2', '1/3'].map(&:to_r)
      end

      it 'can calculate for 0' do
        expect(DrunkenMathematician.worthless(0)).to eq []
      end
    end
  end
end