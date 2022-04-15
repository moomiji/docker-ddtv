#!/bin/bash
set -e; set -u
# $1: $*_PROJECT in DDTV_Docker_Release.yml#L16
# $2: -alpine 或 -focal 等 docker-dotnet 标签系统后缀

# 复用 Dockerfile
sed -i "/FROM/s/$/&${2:-}/g" "$1/Dockerfile"
case $1 in
    ddtv/deps)
        exit 0
        ;;
    ddtv/cli)
        Keyword=CLI
        ;;
    ddtv/webserver)
        Keyword=WEBServer
        ;;
    ddtv/webui)
        Keyword=WEBServer
        is_nginx=true
        ;;
esac
        KeyFile=DDTV_Core.dll

# 下载DDTV
wget -q https://api.github.com/repos/CHKZL/DDTV/releases/latest                                      \
     && wget -q  "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i $Keyword )"       \
     && File_Path=$(cat < latest | awk '/name/{print $4}' FS='"'         | grep -i $Keyword )        \
     && echo "$File_Path downloaded"                                                                 \
     && File_Path=$(unzip "$File_Path" | awk "/$KeyFile/{print \$2}" | awk '{print $1}' FS="$KeyFile") \
     && echo "File path geted"

# 转移DDTV
mkdir -vp "$1/root/DDTV"         \
          "$1/root/DDTV_Backups"
mv -v "$File_Path/*"             \
          "$1/root/DDTV_Backups"
mv -v ./checkup.sh               \
          "$1/root"

if [ -n "${is_nginx:-}" ]; then
    mv -v "$1/root/checkup.sh"  \
          "$1/root/docker-entrypoint.d/01-checkup.sh"
    cd "$1/root/DDTV_Backups"
    rm -rf !(keep|keep2)
fi