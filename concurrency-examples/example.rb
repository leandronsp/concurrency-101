greeting = 'Hello from the main process!'

puts "Main process: #{Process.pid}"

thread = Thread.new do
  puts "Thread process: #{Process.pid}"
  puts "Printing the message sharing the same process: #{greeting}"
end

thread.join
