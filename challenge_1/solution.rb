def compose(f, g)
  lambda do |n|
    first_result = g.call(n)
    f.call(first_result)
  end
end

def complement(f)
  ->(n) {f.call n}
end

# Test Compose Method
add_two = ->(n) { n + 2 }
is_answer = ->(n) { n == 42 }
p "Compose called with 40: ", compose(is_answer, add_two).call(40) # => true
p "Compose called with 10: ", compose(is_answer, add_two).call(10) # => false

# Test Complement Method
is_answer = ->(n) { n == 42 }
not_answer = complement(is_answer)
p "Complement test:"
p not_answer.call(42) # => false
p not_answer.call(12) # => true


