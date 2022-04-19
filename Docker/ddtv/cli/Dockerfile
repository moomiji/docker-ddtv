ARG REPO
FROM ${REPO}
ENV DDTV_Docker_Project=DDTV_CLI \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /
# WORKDIR /DDTV
EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./start.sh"]
