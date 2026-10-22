build.dev:
	docker buildx build . -t 'numendo/php:8.1-apache-dev'
build.and.push:
	docker buildx build . -t 'numendo/php:8.1-apache' --platform linux/amd64,linux/arm64 --push
