build.dev:
	docker buildx build . --pull -t 'numendo/wordpress:8.4-apache-dev'
build.and.push:
	docker buildx build . --pull -t 'numendo/wordpress:8.4-apache' --platform linux/amd64,linux/arm64 --push
