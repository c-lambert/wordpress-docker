# wordpress-docker

#### Créer le builder
Voir Makefile

#### Build une nouvelle image
```
docker buildx build nom_du_dossier -t 'nom:tag'
```
``
docker buildx build . -t 'numendo/php:8.0.13-apache-buster'
``

#### Push l'image
```
docker push 'nom/tag'
```
``
docker push 'numendo/php:8.0.13-apache-buster'
``
