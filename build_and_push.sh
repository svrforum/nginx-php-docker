#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define image names and tags
PHP_FPM_IMAGE="svrforum/ds-php-fpm"
PHP_FPM_TAG="8.5"
NGINX_IMAGE="svrforum/ds-nginx"
NGINX_TAG="1.28"
PLATFORMS="linux/amd64,linux/arm64"

echo "Building Docker images..."

# Build PHP-FPM image (multi-platform)
echo "Building ${PHP_FPM_IMAGE}:${PHP_FPM_TAG} for ${PLATFORMS}..."
docker buildx build --platform "${PLATFORMS}" \
    -t "${PHP_FPM_IMAGE}:${PHP_FPM_TAG}" \
    -f php-fpm/Dockerfile \
    --push .
echo "Successfully built and pushed ${PHP_FPM_IMAGE}:${PHP_FPM_TAG}"

# Build Nginx image (multi-platform)
echo "Building ${NGINX_IMAGE}:${NGINX_TAG} for ${PLATFORMS}..."
docker buildx build --platform "${PLATFORMS}" \
    -t "${NGINX_IMAGE}:${NGINX_TAG}" \
    -f nginx/Dockerfile \
    --push .
echo "Successfully built and pushed ${NGINX_IMAGE}:${NGINX_TAG}"

echo "All Docker images built and pushed successfully!"
