# ds-build

이 저장소는 Nginx와 PHP-FPM을 사용하는 PHP 웹 애플리케이션을 위한 Docker 기반 인프라를 제공합니다.

## 프로젝트 구조

- `php-fpm/`: PHP-FPM 서비스(PHP 8.4)를 위한 Dockerfile을 포함합니다.
- `nginx/`: Nginx 웹 서버를 위한 Dockerfile을 포함합니다.
- `build_and_push.sh`: Docker 이미지를 빌드하고 Docker Hub에 푸시하는 bash 스크립트입니다.

## Docker 이미지 빌드 및 푸시

Docker 이미지를 빌드하고 푸시하려면 제공된 `build_and_push.sh` 스크립트를 사용하십시오.

**시작하기 전에:**
1.  Docker가 설치되어 있고 실행 중인지 확인하십시오.
2.  `docker login`을 사용하여 Docker Hub에 로그인하십시오.

**단계:**

1.  스크립트를 실행 가능하게 만드십시오 (아직 안 했다면):
    ```bash
    chmod +x build_and_push.sh
    ```
2.  스크립트를 실행하십시오:
    ```bash
    ./build_and_push.sh
    ```

이 스크립트는 다음을 수행합니다:
- `dalso/ds-php-fpm:8.4-alpine` 이미지를 빌드합니다.
- `dalso/ds-nginx:alpine` 이미지를 빌드합니다.
- 두 이미지를 Docker Hub에 푸시합니다.

## 사용법

이 프로젝트는 기본 Docker 이미지를 제공합니다. 완전한 웹 애플리케이션을 실행하려면 일반적으로 다음을 수행합니다:

1.  PHP 애플리케이션 코드를 적절한 디렉토리(예: `src/` 또는 `app/`)에 배치하십시오.
2.  애플리케이션을 제공하고 PHP-FPM 서비스로 요청을 프록시하기 위한 Nginx 구성 파일(예: `nginx/conf.d/default.conf`)을 생성하십시오.
3.  `docker-compose.yml`을 사용하여 `nginx` 및 `php-fpm` 서비스를 오케스트레이션하고, 애플리케이션 코드와 Nginx 구성을 볼륨으로 마운트하십시오.
