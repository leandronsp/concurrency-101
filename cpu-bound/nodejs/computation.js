const times = () => {
  return Array.from(Array(300).keys())
}

const fib = (n) => {
  if (n < 2) return n

  return fib(n - 1) + fib(n - 2)
}

const computation = () => {
  fib(25)
}

module.exports = {
  computation,
  times
}
