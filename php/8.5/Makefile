build.dev:
	docker buildx build . -t 'numendo/php:8.5-apache-dev' --target=dev
build.and.push:
	docker buildx build . -t 'numendo/php:8.5-apache' --target=production --platform linux/amd64,linux/arm64 --push
