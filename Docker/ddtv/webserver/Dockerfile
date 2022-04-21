ARG REPO
FROM ${REPO}
ENV DDTV_Docker_Project=DDTV_WEB_Server \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /
WORKDIR /DDTV
EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["/docker-entrypoint.sh"]
