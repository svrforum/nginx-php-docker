#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define image names and tags
PHP_FPM_IMAGE="dalso/ds-php-fpm"
PHP_FPM_TAG="8.4-alpine"
NGINX_IMAGE="dalso/ds-nginx"
NGINX_TAG="alpine"

echo "Building Docker images..."

# Build PHP-FPM image
echo "Building ${PHP_FPM_IMAGE}:${PHP_FPM_TAG}..."
docker build -t "${PHP_FPM_IMAGE}:${PHP_FPM_TAG}" -f php-fpm/Dockerfile .
echo "Successfully built ${PHP_FPM_IMAGE}:${PHP_FPM_TAG}"

# Build Nginx image
echo "Building ${NGINX_IMAGE}:${NGINX_TAG}..."
docker build -t "${NGINX_IMAGE}:${NGINX_TAG}" -f nginx/Dockerfile .
echo "Successfully built ${NGINX_IMAGE}:${NGINX_TAG}"

echo "Docker images built successfully."

# Check if user is logged into Docker Hub
echo "Checking Docker Hub login status..."
if ! docker info | grep -q "Username"; then
    echo "You are not logged into Docker Hub. Please log in using 'docker login' before pushing images."
    exit 1
fi

echo "Pushing Docker images to Docker Hub..."

# Push PHP-FPM image
echo "Pushing ${PHP_FPM_IMAGE}:${PHP_FPM_TAG}..."
docker push "${PHP_FPM_IMAGE}:${PHP_FPM_TAG}"
echo "Successfully pushed ${PHP_FPM_IMAGE}:${PHP_FPM_TAG}"

# Push Nginx image
echo "Pushing ${NGINX_IMAGE}:${NGINX_TAG}..."
docker push "${NGINX_IMAGE}:${NGINX_TAG}"
echo "Successfully pushed ${NGINX_IMAGE}:${NGINX_TAG}"

echo "All Docker images built and pushed successfully!"
