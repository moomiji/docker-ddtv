ARG REPO
FROM ${REPO}
ENV DDTV_Docker_Project=DDTV_WEBUI \
    TZ=Asia/Shanghai \
    WEBUI_Path=/DDTV/static \
    PROXY_PASS=http://DDTV.WEBServer:11419
COPY root/ /
  # .sh file     in /docker-entrypoint.d
  # 前端配置文件  in /DDTV/static
  # default.conf in /etc/nginx/conf.d

RUN apk add --no-cache bash \
    && rm -rf /var/cache/apk/* /root/.cache /tmp/* \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
WORKDIR /DDTV
