initial_time = Time.now

# [1, 2, 3, 4, 5]
queue = Array.new

job_1 = lambda do
  100.times do
    #puts 'Job 1'
    sleep 0.005
  end
end

job_2 = lambda do
  100.times do
    #puts 'Job 2'
    sleep 0.005
  end
end

queue << job_1
queue << job_2

queue.shift.call
queue.shift.call

puts queue.size

puts "Done in #{Time.now - initial_time}"
