def reverse(word)
  letters = word.split('')

  letters
    .each_with_index
    .map { |_, idx| letters[-1 - idx] }
    .join
end

def palindrome?(word)
  word == reverse(word)
end

def random_word
  letters = 'abcdefghijklmnopqrstuvxz'.split('')
  size    = [3, 4, 5].sample

  (1..size).reduce('') do |acc, _|
    random_idx = (0..23).to_a.sample

    acc << letters[random_idx]
    acc
  end
end

def palindromes_from(limit)
  limit
    .times
    .map { random_word }
    .select { |word| palindrome?(word) }
end

puts reverse('leandro')
puts palindrome?('leandro')
puts palindrome?('ana')
puts random_word
puts palindromes_from(1000)
