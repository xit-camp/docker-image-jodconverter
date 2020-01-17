.DEFAULT_GOAL := build
.PHONY: build deploy

VERSION := $(shell sed -n -e 's/^.\+JOD_VERSION\s*=\s*\(.\+\)/\1/p' < Dockerfile)

build:
	docker build --target jodconverter-base . -t docker.xit.camp/library/jodconverter-base:${VERSION}
	docker build --target gui . -t docker.xit.camp/library/jodconverter-gui:${VERSION}
	docker build --target rest . -t docker.xit.camp/library/jodconverter-rest:${VERSION}

deploy:
	docker push docker.xit.camp/library/jodconverter-base:${VERSION}
	docker push docker.xit.camp/library/jodconverter-gui:${VERSION}
	docker push docker.xit.camp/library/jodconverter-rest:${VERSION}

start-gui: stop
	docker run --name jodconverter-spring -m 512m --rm -p 8080:8080 docker.xit.camp/library/jodconverter-gui:${VERSION}

start-rest: stop
	docker run --name jodconverter-rest -m 512m --rm -p 8080:8080 docker.xit.camp/library/jodconverter-rest:${VERSION}

stop:
	docker stop --name jodconverter-rest > /dev/null 2>&1 || true
	docker stop --name jodconverter-spring > /dev/null 2>&1 || true