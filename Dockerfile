# Python 3.12 이미지로부터 시작
FROM python:3.12-slim

# 필수 패키지 설치 (nginx 및 Supervisor 포함)
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && apt-get clean

# Flask 앱이 저장될 위치
WORKDIR /app

# 파이썬 종속성 파일 복사
COPY requirements.txt requirements.txt

# Flask 패키지 설치
RUN pip install -r requirements.txt

# Nginx 설정 파일 복사
COPY  ./nginx.conf /etc/nginx/nginx.conf

# Supervisor 설정 파일 복사
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Flask 애플리케이션 복사
COPY app.py /app

# 업로드된 이미지가 저장될 디렉토리
RUN mkdir -p /usr/share/nginx/html/images

# 컨테이너가 80 포트를 사용할 수 있도록 설정
EXPOSE 80
EXPOSE 5000

# FLASK_APP 환경 변수를 설정
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000

# Supervisor를 통해 Nginx와 Flask 애플리케이션을 동시에 실행
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

