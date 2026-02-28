# 기반 이미지 설정
FROM nginx:1.28-alpine

# logrotate 설치
RUN apk add --no-cache logrotate

# logrotate 설정 파일 복사
COPY nginx/logrotate/nginx /etc/logrotate.d/nginx

# Nginx 로그 디렉토리 생성
RUN mkdir -p /var/log/nginx

# logrotate 실행
CMD ["sh", "-c", "crond && nginx -g 'daemon off;'"]
