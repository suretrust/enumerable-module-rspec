# recreating some methods in Enumerable module
module Enumerable
  def my_each
    if is_a? Array
      (0..length - 1).each do |i|
        yield self[i]
      end
    elsif is_a? Hash
      keys.each do |k|
        yield k, self[k]
      end
    end
  end

  def my_each_with_index
    if is_a? Array
      (0..length - 1).each do |i|
        yield(self[i], i)
      end
    elsif is_a? Hash
      (0..keys.length - 1).each do |k|
        yield([keys[k], values[k]], k)
      end
    end
  end

  def my_select
    if is_a? Array
      result = []
      my_each { |item| result.push(item) if yield(item) }
      result
    elsif is_a? Hash
      result = Hash.new(0)
      my_each { |k, v| result[k] = v if yield(k, v) }
      result
    end
  end

  def my_all?(*arg, &block)
    result = true
    if block_given?
      result = my_all_block(result, &block)
    elsif arg.empty?
      result = my_all_empty_arg(result)
    else
      arg.my_each { |a| result = my_all_not_block(result, a) }
    end
    result
  end

  def my_any?(*arg, &block)
    result = false
    if block_given?
      result = my_any_block(result, &block)
    elsif arg.empty?
      result = my_any_empty_arg(result)
    else
      arg.my_each { |a| result = my_any_arg(result, a) }
    end
    result
  end

  def my_none?(*arg, &block)
    result = true

    if block_given?
      result = my_none_block(result, &block)
    elsif arg.empty?
      result = my_none_empty_arg(result)
    else
      arg.my_each { |a| result = my_none_else(result, a) }
    end
    result
  end

  def my_count(arg = nil, &block)
    count = 0
    if block_given?
      my_count_block(count, &block)
    elsif arg.nil?
      length
    else
      my_count_not_block(count, arg)
    end
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    result = []
    if is_a? Range
      to_a.my_each { |item| result.push(yield(item)) }
    elsif is_a? Array
      my_each { |item| result.push(yield(item)) }
    elsif is_a? Hash
      my_each { |k, v| result.push(yield(k, v)) }
    end
    result
  end
end

# aux methods for my_all?
def my_all_block(result)
  if is_a? Array
    my_each do |item|
      result = false unless yield(item)
    end
  elsif is_a? Hash
    my_each do |k, v|
      result = false unless yield(k, v)
    end
  end
  result
end

def my_all_not_block(result, arg)
  if arg.is_a? Class
    my_all_arg_class(result, arg)
  else
    my_all_arg_class_else(result, arg)
  end
end

def my_all_empty_arg(result)
  if is_a? Array
    my_each { |item| result = false unless item }
  elsif is_a? Hash
    my_each { |k, v| result = false unless v[k] }
  end
  result
end

def my_all_arg_class(result, arg)
  if is_a? Array
    my_each do |item|
      result = false unless item.is_a? arg
    end
  elsif is_a? Hash
    my_each do |k, v|
      result = false unless v[k].is_a? arg
    end
  end
  result
end

def my_all_arg_class_else(result, arg)
  if is_a? Array
    my_each do |item|
      result = false unless item == arg
    end
  elsif is_a? Hash
    my_each do |k, v|
      result = false unless v[k] == arg
    end
  end
  result
end

# aux methods for my_any?
def my_any_block(result)
  if is_a? Array
    my_each { |item| result = true if yield(item) }
  elsif is_a? Hash
    my_each { |k, v| result = true if yield(k, v) }
  end
  result
end

def my_any_empty_arg(result)
  if is_a? Array
    my_each { |item| result = true if item }
  elsif is_a? Hash
    my_each { |k, v| result = true if v[k] }
  end
  result
end

def my_any_arg_class(result, arg)
  if is_a? Array
    my_each do |item|
      result = true if item.is_a? arg
    end
  elsif is_a? Hash
    my_each do |k, v|
      result = true if v[k].is_a? arg
    end
  end
  result
end

def my_any_arg_clas_else(result, arg)
  if is_a? Array
    my_each do |item|
      result = true if item == arg
    end
  elsif is_a? Hash
    my_each do |k, v|
      result = true if v[k] == arg
    end
  end
  result
end

def my_any_arg(result, arg)
  if arg.is_a? Class
    my_any_arg_class(result, arg)
  else
    my_any_arg_clas_else(result, arg)
  end
end

# aux methods for my_none?
def my_none_block(result)
  my_each do |k, v|
    if ((is_a? Array) && yield(k)) || ((is_a? Hash) && yield(k, v))
      result = false
      break
    end
  end
  result
end

def my_none_empty_arg(result)
  my_each do |k, v|
    if ((is_a? Array) && k) || ((is_a? Hash) && v[k])
      result = false
      break
    end
  end
  result
end

def my_none_else_class(result, arg)
  my_each do |k, v|
    if ((is_a? Array) && (k.is_a? arg)) || ((is_a? Hash) && (v[k].is_a? arg))
      result = false
      break
    end
  end
  result
end

def my_none_else_else(result, arg)
  my_each do |k, v|
    if ((is_a? Array) && (k == arg)) || ((is_a? Hash) && (v[k] == arg))
      result = false
      break
    end
  end
  result
end

def my_none_else(result, arg)
  if arg.is_a? Class
    my_none_else_class(result, arg)
  else
    my_none_else_else(result, arg)
  end
end

def my_count_block(count)
  if is_a? Array
    my_each do |item|
      count += 1 if yield(item)
    end
  elsif is_a? Hash
    my_each do |k, v|
      count += 1 if yield(k, v)
    end
  end
  count
end

def my_count_not_block(count, arg)
  if is_a? Array
    my_each { |item| count += 1 if item == arg }
  elsif is_a? Hash
    my_each { |_k, v| count += 1 if v == arg }
  end
  count
end

# puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_all?(/t/)                        #=> false
# puts [1, 2i, 3.14].my_all?(Numeric)                       #=> true
# puts [nil, true, 99].my_all?                              #=> false
# puts [].my_all?                                           #=> true
#
#
# puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# puts %w[ant bear cat].my_any?(/d/)                        #=> false
# puts [nil, true, 99].my_any?(Integer)                     #=> true
# puts [nil, true, 99].my_any?                              #=> true
# puts [].my_any?                                           #=> false
# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count(&:even?) #=> 3
#
# puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.my_none?(/d/)                        #=> true
# puts [1, 3.14, 42].my_none?(Float)                         #=> false
# puts [].my_none?                                           #=> true
# puts [nil].my_none?                                        #=> true
# puts [nil, false].my_none?                                 #=> true
# puts [nil, false, true].my_none?                           #=> false
#
# ary = [1, 2, 4, 2]
# ary.my_each { |x| puts x }
