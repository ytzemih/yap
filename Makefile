.PHONY: run shell build clean

SERVICE=supervisor-workflow

run: build
	docker-compose run --rm ${SERVICE}

build:
	docker-compose build

clean:
	rm -rf ./files/yap-examples

shell: build
	docker-compose run --rm ${SERVICE} bash