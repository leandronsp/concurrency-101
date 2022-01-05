def times
  300
end

def computation
  fib(25)
end

def fib(n)
  n < 2 ? n : fib(n - 1) + fib(n - 2)
end
