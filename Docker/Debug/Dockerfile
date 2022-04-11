FROM mcr.microsoft.com/dotnet/sdk:6.0
ENV DDTV_Project=Debug \
    PATH="/tools:${PATH}" \
    Logging__Console__FormatterName= \
    DOTNET_PerfMapEnabled=1 \
    DOTNET_EnableEventLog=1 \
    DOTNET_ZapDisable=1 \
    TZ=Asia/Shanghai
COPY root/ /

RUN ./install-deps.sh

CMD ["/bin/sh"]
