require './lib/main'

RSpec.describe Enumerable do
  describe '#my_each' do
    a = %w[a b c]
    b = %w[1 2 3]
    c = { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 }
    aux = ''
    sum = 0
    result = []
    result2 = 0
    it 'returns the concatenation of all letters in the array' do
      a.my_each { |x| aux += x }
      expect(aux).to eql('abc')
    end
    it 'returns the sum of all numbers in the array' do
      b.my_each { |x| sum += x.to_i }
      expect(sum).to eql(6)
    end
    it 'returns only the even values in the hash' do
      c.my_each { |_k, v| result.push(v) if v.even? }
      expect(result).to eql([2, 4, 6])
    end
    it "returns the value that has key 'a'" do
      c.my_each { |k, v| result2 = v if k == :a }
      expect(result2).to eql(1)
    end
  end
end

RSpec.describe Enumerable do
  describe '#my_select' do
    it 'returns all the items in the array that are multiples of 3' do
      expect((1..10).to_a.my_select { |i|  i % 3 == 0 }).to eql([3, 6, 9])
    end

    it 'returns all the even items in the array' do
      expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
    end

    it "returns the 'foo' symbols in the array" do
      expect(%i[foo bar].my_select { |x| x == :foo }).to eql([:foo])
    end

    test_hash = { 'a' => 100, 'b' => 200, 'c' => 300 }

    it "returns the key/value pairs with a key greater than 'a'" do
      expect(test_hash.my_select { |k, _v| k > 'a' })
        .to eql('b' => 200, 'c' => 300)
    end

    it 'returns the key/value pairs with a values is smaller than 200' do
      expect(test_hash.my_select { |_k, v| v < 200 }).to eql('a' => 100)
    end
  end
end

RSpec.describe Enumerable do
  describe '#my_count' do
    test_arr = [1, 2, 4, 2]

    it 'returns the length of the array' do
      expect(test_arr.my_count).to eql(4)
    end

    it 'returns the number of occurrences of the number 2' do
      expect(test_arr.my_count(2)).to eql(2)
    end

    it 'returns the amount of even numbers' do
      expect(test_arr.my_count(&:even?)).to eql(3)
    end

    test_hash = { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 }

    it 'returns the length of the hash' do
      expect(test_hash.my_count).to eql(6)
    end

    it 'returns the amount of uneven values' do
      expect(test_hash.my_count { |_k, v| v.odd? }).to eql(3)
    end

    it "returns the amount of keys greater than 'e'" do
      expect(test_hash.my_count { |k, _v| k.to_s > 'e' }).to eql(1)
    end
  end
end

RSpec.describe Enumerable do
  describe '#my_all?' do
    it 'returns true if all words have a length of 3 or more' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns true if all items are Numeric' do
      expect([1, 2i, 3.14].all?(Numeric)).to eql(true)
    end
    it 'returns false if not all match the expression /t/' do
      expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
    end
    it 'returns false if not all are true' do
      expect([nil, true, 99].my_all?).to eql(false)
    end
    it 'returns true if the array is empty' do
      expect([].my_all?).to eql(true)
    end

    hash_test = { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 }

    it 'returns true if all the values of the hash are positive' do
      expect(hash_test.my_all? { |_k, v| v >= 0 }).to eql(true)
    end
    it 'returns false if not all keys are strings' do
      expect(hash_test.my_all? {|key, value| key.is_a? String}).to eql(false)
    end
  end
end

RSpec.describe Enumerable do
  describe '#my_any?' do
    it "returns true if any of the word's length is 3 or more" do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql(true)
    end
    it "returns true if any of the items is true" do
      expect([nil, true, 99].my_any?).to eql(true)
    end
    h = {"a" => 1, "b" => 2, "c" => 3}
    it "returns false since none of the values is a string" do
      expect(h.my_any? {|key, value| value.is_a? String}).to eql(false)
    end
  end
end
