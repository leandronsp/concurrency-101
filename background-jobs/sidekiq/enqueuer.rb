require 'sidekiq'
require './background-jobs/sidekiq/sleeper-worker'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

(1..10).each do |idx|
  SleeperWorker.perform_async(2)
end
