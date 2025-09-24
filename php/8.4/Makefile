build.dev:
	docker build . -t 'numendo/php:8.4-apache-dev' --target=dev --progress plain --platform linux/amd64
build:
	docker build . -t 'numendo/php:8.4-apache' --target=production --progress plain --platform linux/amd64
push.dev:
	docker push 'numendo/php:8.4-apache-dev'
push:
	docker push 'numendo/php:8.4-apache'
