build:
	docker buildx build . -t 'numendo/wordpress:7.4-apache-buster' --no-cache --platform linux/amd64,linux/arm64
push:
	docker push 'numendo/wordpress:7.4-apache-buster'
