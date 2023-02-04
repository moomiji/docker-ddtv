#!/bin/bash
set -e; set -u
# $1: $*_REPO in Docker_Release.yml#L28-40
# $2: ${{ secrets.GITHUB_TOKEN }}
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
        is_webui=true
        ;;
esac
KeyFile=DDTV_Core.dll
shopt -s globstar nullglob
cd ./**/$1

header="authorization: Bearer $2"
# 下载DDTV
curl -sfLOH "$header" "https://api.github.com/repos/CHKZL/DDTV/releases/latest"                              \
     && curl -sfLOH "$header" "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i $Keyword )"  \
     && File_Path="$(            cat < latest | awk '/name/{print $4}'         FS='"' | grep -i $Keyword )" \
     && 7z x -bd "$File_Path"                                                                               \
     && echo "Extract ($File_Path) succeeded"                                                               \
     && File_Path=$(7z l "$File_Path" | awk "/$KeyFile/{print \$6}" | awk '{print $1}' FS="/$KeyFile")      \
     && echo "File path ($File_Path) geted"                                                                 \
     || eval 'echo "Failed to get File path OR extract" && exit 1'

# 转移DDTV
mkdir -vp ./root/DDTV
mv -v $File_Path                \
          ./root/DDTV_Backups
mv -v ../docker-entrypoint.sh \
          ./root
mv -v ../*-*.sh         \
          ./root/docker-entrypoint.d

shopt -s extglob
if [ -n "${is_webui:-}" ]; then
    rm  "./root/docker-entrypoint.sh"
    cd  "./root/DDTV_Backups"
    rm -rf !(keep|keep2)
fi
