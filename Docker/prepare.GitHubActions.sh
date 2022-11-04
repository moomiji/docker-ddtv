#!/bin/bash
set -e; set -u
# $1: $*_REPO in Docker_Release.yml#L28-40
case $1 in
    ddtv/deps)
        exit 0
        ;;
    ddtv/cli)
        Keyword=CLI
        ;;
    ddtv/webserver)
        Keyword=Server
        ;;
    ddtv/webui)
        Keyword=Server
        is_nginx=true
        ;;
esac
KeyFile=DDTV_Core.dll

# 下载DDTV
wget --no-verbose https://github.com/moomiji/docker-ddtv/releases/download/edge/webui-20221104.zip
7z x -bd webui-20221104.zip
ls -al
mv -v disk/ static/
File_Path=./static


# 转移DDTV
mkdir -vp "$1/root/DDTV"
mv -v "$File_Path"               \
          "$1/root/DDTV_Backups"
mv -v ./*-checkup.sh             \
          "$1/root/docker-entrypoint.d"
mv -v ./docker-entrypoint.sh     \
          "$1/root"

shopt -s extglob
if [ -n "${is_nginx:-}" ]; then
    rm  "$1/root/docker-entrypoint.sh"
#    cd  "$1/root/DDTV_Backups"
#    rm -rf !(keep|keep2)
fi
