ARG REPO
FROM ${REPO}
# DDTV_Docker_Project被用于DDTV内部启动类型的判断
ENV DDTV_Docker_Project=DDTV_CLI \
    TZ=Asia/Shanghai
COPY root/ /
RUN cd /docker-entrypoint.d && ./install-deps.sh
WORKDIR /DDTV
ENTRYPOINT ["/docker-entrypoint.sh"]
