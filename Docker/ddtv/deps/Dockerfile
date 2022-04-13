ARG DOTNET_VERSION
FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION}
COPY root/ /
RUN ./install-deps.sh
