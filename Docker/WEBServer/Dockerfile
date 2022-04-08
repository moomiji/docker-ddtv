ARG REPO
FROM $REPO
ENV DDTV_Project=WEBServer \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

RUN ./install.sh && rm -v ./install.sh

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./WEBServer.sh"]
