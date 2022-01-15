require 'csv'
require 'byebug'

initial_time = Time.now

total = 0
chunks = []

10.times.map do |idx|
  File.open("./live-coding/files/users_#{idx + 1}.csv") do |file|
    file.lazy.each_slice(100) do |lines|
      chunks << CSV.parse(lines.join)
    end
  end
end

byebug

chunks.each do |chunk|
  chunk.each do |row|
    total +=  row[1].to_i
  end
end

puts "Total: #{total}"
puts "Done in #{Time.now - initial_time} seconds"
