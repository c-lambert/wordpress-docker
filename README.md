# wordpress-docker

## Maintained versions

One image per PHP minor version still serving a site, on a Debian release under Debian LTS. Any other
version is removed from this repository and from Docker Hub.

| PHP | Images | Debian | Base |
|---|---|---|---|
| 7.4 | `numendo/php:7.4-apache`, `numendo/wordpress:7.4-apache` | 12 bookworm | `debian:bookworm-slim` + packages from the sury repository (no official image: PHP 7.4 does not support OpenSSL 3) |
| 8.1 | `numendo/php:8.1-apache`, `numendo/wordpress:8.1-apache` | 12 bookworm | `php:8.1-apache-bookworm`, PHP rebuilt with the CVE-2026-109618 and CVE-2026-109619 fix (8.1 is end of life) |
| 8.2 | `numendo/php:8.2-apache`, `numendo/wordpress:8.2-apache` | 12 bookworm | `php:8.2-apache-bookworm` |
| 8.3 | `numendo/php:8.3-apache`, `numendo/wordpress:8.3-apache` | 12 bookworm | `php:8.3-apache-bookworm` |
| 8.4 | `numendo/php:8.4-apache`, `numendo/wordpress:8.4-apache` | 13 trixie | `php:8.4-apache-trixie` |
| 8.5 | `numendo/php:8.5-apache`, `numendo/wordpress:8.5-apache` | 13 trixie | `php:8.5-apache-trixie` |

Only `numendo/php:x.y-apache` and `numendo/wordpress:x.y-apache` tags are published: no distribution
suffix, no patch version, no `-dev` image.

## Makefile convention

- `make build.and.push`: Create and publish a multi-platform image 
- `build.dev` : Locally create the image in order to test it


## Setup

The multi-platform build is handled with a specific docker container.
Before building multi-platform image you have to set it up, all the instructions are in the `/Makefile`.

## Testing

- Build the image locally with `build.dev`
- Define your custom local image inside `/test/docker-compose.yaml` with the `-dev` suffix
- Start the container
