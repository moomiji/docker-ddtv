FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV DDTV_Project=CLI \
    Logging__Console__FormatterName= \
    TZ=Asia/Shanghai
COPY root/ /

RUN ./install.sh && rm -v ./install.sh

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./CLI.sh"]
