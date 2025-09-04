build.dev:
	docker build . -t 'numendo/php:8.2-apache-dev' --target=dev --progress plain --platform linux/amd64,linux/arm64
build:
	docker build . -t 'numendo/php:8.2-apache' --target=init --progress plain --platform linux/amd64,linux/arm64
push.dev:
	docker push 'numendo/php:8.2-apache-dev'
push:
	docker push 'numendo/php:8.2-apache'
