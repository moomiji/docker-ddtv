ARG REPO
FROM ${REPO}
ENV DDTV_Docker_Project=WEBServer \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./WEBServer.sh"]
