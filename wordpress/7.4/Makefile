build.dev:
	docker buildx build . -t 'numendo/wordpress:7.4-apache-dev'
build.and.push:
	docker buildx build . -t 'numendo/wordpress:7.4-apache' --platform linux/amd64,linux/arm64 --push
