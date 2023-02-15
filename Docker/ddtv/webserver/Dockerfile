ARG REPO
FROM ${REPO}
# DDTV_Docker_Project被用于DDTV内部启动类型的判断
ENV DDTV_Docker_Project=DDTV_WEB_Server \
    TZ=Asia/Shanghai
COPY root/ /
WORKDIR /DDTV
EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["/docker-entrypoint.sh"]
