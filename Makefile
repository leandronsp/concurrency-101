bash:
	@docker-compose run \
		--use-aliases \
		app \
		bash

gems.install:
	@docker-compose run app \
		gem install sidekiq async-io async-http redis pg faker

server.sync:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "ruby web/sync-server.rb"

server.fiber:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "ruby web/fiber-server.rb"

server.threaded:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "ruby web/threaded-server.rb"

server.ractor:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "ruby web/ractor-server.rb"

server.sleeper.api:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		sleeper

redis:
	@docker-compose run \
		--use-aliases \
		redis

postgres:
	@docker-compose run \
		--rm \
		--name test-db \
		--use-aliases \
		--service-ports \
		postgres

psql:
	@docker exec \
		-it \
		test-db \
		psql -U test test

seed.postgres:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "ruby web/database/postgres/seed.rb"
