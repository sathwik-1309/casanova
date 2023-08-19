# Docker

## Create Docker image without cache
    docker build --no-cache -t casanova-backend:v1 .

## Tag the image
    docker tag casanova-backend:v1 sathwik139/casanova-backend:v1

## Push to dockerhub
    docker push sathwik139/casanova-backend:v1

## Pull docker image
    docker pull sathwik139/casanova-backend:v1

## Run backend container
    docker run -p 3001:3001 casanova:backend

## Run frontend container
    docker run -p 3000:3000 casanova:frontend

# Docker push amd64
    docker buildx build --platform linux/amd64 -t your_image_name:your_tag --push .






