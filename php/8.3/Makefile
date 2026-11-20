build.dev:
	docker buildx build . --pull -t 'numendo/php:8.3-apache-dev' --target=dev
build.and.push:
	docker buildx build . --pull -t 'numendo/php:8.3-apache' --target=production --platform linux/amd64,linux/arm64 --push
