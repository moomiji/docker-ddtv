FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV DDTV_Project=WEBServer \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

RUN apt update || apk add bash && ./install.sh && rm -v ./install.sh

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./WEBServer.sh"]
