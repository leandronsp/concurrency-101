require 'sidekiq'

class SleeperWorker
  include Sidekiq::Worker

  def perform(sleep_time)
    puts "[Sleeper] Args: #{sleep_time}"

    sleep sleep_time
  end
end
