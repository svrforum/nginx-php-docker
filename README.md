# ds-build

This repository provides Docker-based infrastructure for a PHP web application using Nginx and PHP-FPM.

## Project Structure

- `php-fpm/`: Contains the Dockerfile for the PHP-FPM service (PHP 8.4).
- `nginx/`: Contains the Dockerfile for the Nginx web server.
- `build_and_push.sh`: A bash script to build and push the Docker images to Docker Hub.

## Building and Pushing Docker Images

To build and push the Docker images, use the provided `build_and_push.sh` script.

**Before you start:**
1.  Ensure you have Docker installed and running.
2.  Log in to Docker Hub using `docker login`.

**Steps:**

1.  Make the script executable (if not already):
    ```bash
    chmod +x build_and_push.sh
    ```
2.  Run the script:
    ```bash
    ./build_and_push.sh
    ```

This script will:
- Build the `dalso/ds-php-fpm:8.4-alpine` image.
- Build the `dalso/ds-nginx:alpine` image.
- Push both images to Docker Hub.

## Usage

This project provides the base Docker images. To run a complete web application, you will typically:

1.  Place your PHP application code in a suitable directory (e.g., `src/` or `app/`).
2.  Create an Nginx configuration file (e.g., `nginx/conf.d/default.conf`) to serve your application and proxy requests to the PHP-FPM service.
3.  Use `docker-compose.yml` to orchestrate the `nginx` and `php-fpm` services, mounting your application code and Nginx configuration as volumes.