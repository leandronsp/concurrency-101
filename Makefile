bash:
	@docker-compose run app bash

gems.install:
	@docker-compose run app \
		gem install sidekiq
