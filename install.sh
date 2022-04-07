#!/bin/sh
# WEBServer CLI Debug 安装相关依赖
set -e; set -u

. /etc/os-release

case $ID in
    alpine)
        if [ "${DDTV_Project:-WTF}" = "Debug" ]; then
            apk add --no-cache ffmpeg bash tzdata su-exec perf perl git
            git clone --depth=1 https://github.com/BrendanGregg/FlameGraph
        else
            apk add --no-cache ffmpeg bash tzdata su-exec
        fi
            apk add libgdiplus --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
            sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
        ;;

    debian)
            apt update
        if [ "${DDTV_Project:-WTF}" = "Debug" ]; then
            apt install --no-install-recommends ffmpeg bash tzdata gosu libgdiplus linux-perf perl git -y
            git clone --depth=1 https://github.com/BrendanGregg/FlameGraph
        else
            apt install --no-install-recommends ffmpeg bash tzdata gosu libgdiplus -y
        fi
            apt clean -y
            sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
        ;;
    *)
        echo "Error OS ID: $ID!" && exit 1
esac

rm -rf /var/lib/apt/lists/* /var/cache/apk/* /root/.cache /tmp/*
