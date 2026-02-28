# nginx-php-docker

CMS/웹앱(WordPress, Rhymix 등) 워크로드에 최적화된 PHP-FPM + Nginx Docker 이미지.

## Docker 이미지

| 이미지 | 태그 | 설명 |
|--------|------|------|
| `svrforum/ds-php-fpm` | `8.5` | PHP 8.5 FPM + OPcache/JIT 최적화 |
| `svrforum/ds-nginx` | `1.28` | Nginx 1.28 + logrotate |

### 지원 플랫폼

- `linux/amd64`
- `linux/arm64`

## 주요 사양

### PHP-FPM

- **PHP 확장**: bcmath, exif, gd, intl, mysqli, zip, pdo, pdo_mysql, redis, apcu, imagick, memcached
- **OPcache**: 256MB 메모리, 20000 파일 캐시, JIT tracing 128M
- **PHP 설정**: memory_limit 256M, upload 64M, realpath_cache 4096K, max_input_vars 5000

### Nginx

- Nginx 1.28 stable (Alpine)
- logrotate: daily, 5년 보관, gzip 압축, 연/월 디렉토리 자동 정리

## 사용법

### docker-compose.yml 예시

```yaml
services:
  php-fpm:
    image: svrforum/ds-php-fpm:8.5
    volumes:
      - ./src:/var/www/html

  nginx:
    image: svrforum/ds-nginx:1.28
    ports:
      - "80:80"
    volumes:
      - ./src:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

## 빌드

### 로컬 빌드

```bash
chmod +x build_and_push.sh
./build_and_push.sh
```

### 자동 빌드 (GitHub Actions)

GitHub에서 릴리즈를 생성하면 자동으로 멀티 플랫폼 이미지가 빌드되어 Docker Hub에 푸시됩니다.

```bash
git tag v1.0.0
git push origin v1.0.0
```

## 프로젝트 구조

```
php-fpm/Dockerfile          # PHP-FPM 이미지
nginx/Dockerfile            # Nginx 이미지
nginx/logrotate/nginx       # 로그 로테이션 설정
build_and_push.sh           # 로컬 빌드 스크립트
.github/workflows/release.yml  # CI/CD 워크플로우
```
