@mutex = Mutex.new

size = 20_000

@items = (0..size).to_a

100.times.map do
  Thread.new do
    2_000.times do
      @mutex.synchronize do
        @items.shift

        @items = [0, @items.shift] + @items
      end
    end
  end
end.each(&:join)

if (0..size).to_a == @items
  puts 'No Race condition detected'
else
  puts "Race condition detected"
  puts "Items size: #{@items.size}"
end
