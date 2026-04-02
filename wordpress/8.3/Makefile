build.dev:
	docker buildx build . -t 'numendo/wordpress:8.3-apache-dev'
build.and.push:
	docker buildx build . -t 'numendo/wordpress:8.3-apache' --platform linux/amd64,linux/arm64 --push
