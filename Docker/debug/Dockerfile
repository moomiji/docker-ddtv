ARG DOTNET_VERSION
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}
ENV PATH="/tools:${PATH}" \
    Logging__Console__FormatterName= \
    DOTNET_PerfMapEnabled=1 \
    DOTNET_EnableEventLog=1 \
    DOTNET_ZapDisable=1 \
    TZ=Asia/Shanghai
COPY install.sh /

RUN ./install.sh

CMD ["/bin/sh"]
