ARG REPO
FROM ${REPO}
ENV DDTV_Docker_Project=CLI \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./CLI.sh"]
