build.dev:
	docker buildx build . --pull -t 'numendo/wordpress:8.5-apache-dev'
build.and.push:
	docker buildx build . --pull -t 'numendo/wordpress:8.5-apache' --platform linux/amd64,linux/arm64 --push
