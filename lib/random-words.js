const reverse = (word) => {
  const letters = word.split('')
  const lastIdx = letters.length - 1

  return letters
    .map((letter, idx) => { return letters[lastIdx - idx] })
    .join('')
}

const isPalindrome = (word) => {
  return word === reverse(word)
}

const randomMax = (sizeLimit) => {
  return Math.floor(
    Math.random() * sizeLimit
  )
}

const sample = (list) => {
  const randomIdx = randomMax(list.length)

  return list[randomIdx]
}

const iterateTimes = (times) => {
  return Array.from(Array(times).keys())
}

const randomWord = () => {
  const alphabet = 'abcdefghijklmnopqrstuvxz'.split('')
  const size     = sample([3, 4, 5])

  return iterateTimes(size)
    .reduce((acc) => { return acc.concat(sample(alphabet)) }, '')
}

const palindromesFrom = (limit) => {
  return iterateTimes(limit)
    .map(()        => { return randomWord() })
    .filter((word) => { return isPalindrome(word) })
}

console.log(reverse('leandro'))
console.log(isPalindrome('leandro'))
console.log(isPalindrome('ana'))
console.log(sample([3, 4, 5]))
console.log(randomWord())
console.log(palindromesFrom(1000))
