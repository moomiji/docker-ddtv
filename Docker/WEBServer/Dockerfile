FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV DDTV_Project=WEBServer \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

RUN apt update && apt install bash || apk add bash && ./install.sh && rm ./install.sh

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./start.sh"]
