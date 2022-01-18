ruby:
	@docker-compose run \
		--rm \
		--name ruby \
		--service-ports \
		--use-aliases \
		ruby \
		bash

ruby.attach:
	@docker exec -it ruby bash

nodejs:
	@docker-compose run \
		--rm \
		--name nodejs \
		--service-ports \
		--use-aliases \
		nodejs \
		bash

nodejs.attach:
	@docker exec -it nodejs bash

server.fiber:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "bundle exec ruby web/fiber-server.rb"

server.threaded:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "bundle exec ruby web/threaded-server.rb"

server.ractor:
	@docker-compose run \
		--service-ports \
		--use-aliases \
		app \
		bash -c "bundle exec ruby web/ractor-server.rb"

redis:
	@docker-compose run \
		--rm \
		--use-aliases \
		--name redis \
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
