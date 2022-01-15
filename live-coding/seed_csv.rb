require 'csv'
require 'fileutils'

initial_time = Time.now
FileUtils.mkdir_p('./live-coding/files')

30.times.map do |idx|
  CSV.open("./live-coding/files/users_#{idx + 1}.csv", 'wb') do |csv|
    300_000.times do |uidx|
      csv << ["user_#{uidx + 1}", (1..100).to_a.sample]
    end
  end
end

puts "Done in #{Time.now - initial_time} seconds"
