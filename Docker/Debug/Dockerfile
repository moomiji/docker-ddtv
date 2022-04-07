FROM mcr.microsoft.com/dotnet/sdk:6.0
ENV DDTV_Project=Debug \
    PATH="/tools:${PATH}" \
    Logging__Console__FormatterName= \
    COMPlus_PerfMapEnabled=1 \
    COMPlus_EnableEventLog=1 \
    COMPlus_ZapDisable=1 \
    TZ=Asia/Shanghai
COPY root/ /

RUN ./install.sh && rm ./install.sh

EXPOSE 11419
VOLUME /DDTV/Rec
ENTRYPOINT ["./start.sh"]
