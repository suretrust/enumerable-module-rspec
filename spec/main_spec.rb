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
