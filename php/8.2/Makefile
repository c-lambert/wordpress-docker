build.dev:
	docker buildx build . -t 'numendo/php:8.2-apache-dev' --target=dev --platform linux/amd64,linux/arm64
build:
	docker buildx build . -t 'numendo/php:8.2-apache' --target=init --platform linux/amd64,linux/arm64
push.dev:
	docker push 'numendo/php:8.2-apache-dev'
push:
	docker push 'numendo/php:8.2-apache'
