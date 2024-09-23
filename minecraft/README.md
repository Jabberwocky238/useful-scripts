RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \
' >> /etc/apt/sources.list

# setup
```bash
sudo docker-compose up -d --build mcsmjdk11 && sudo docker-compose logs mcsmjdk11
sudo docker-compose up -d --build mcsmjdk17 && sudo docker-compose logs mcsmjdk17
sudo docker-compose up -d --build mcsmjdk21 && sudo docker-compose logs mcsmjdk21

sudo docker-compose up -d --build mcsm-web && sudo docker-compose logs mcsm-web
```

