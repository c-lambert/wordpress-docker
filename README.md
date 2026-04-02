# wordpress-docker

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
