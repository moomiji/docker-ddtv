#!/bin/bash
set -e; set -u

# 复用 Dockerfile
# $* 为 -alpine、-focal 或其他 docker-dotnet 标签后缀
shopt -s globstar nullglob
for Dockerfile in ./**/Dockerfile; do
    sed -i "/FROM/s/$/&$*/g" "$Dockerfile"
done

# 下载 DDTV
wget -q https://api.github.com/repos/CHKZL/DDTV/releases/latest &&
     echo "latest downloaded"
wget -q -O CLI.zip       "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i CLI   )" &&
     echo "$(cat < latest | awk '/name/{print $4}' FS='"' | grep -i CLI   ) downloaded"
wget -q -O WEBServer.zip "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i Server)" &&
     echo "$(cat < latest | awk '/name/{print $4}' FS='"' | grep -i Server) downloaded"

CLI_DLL_File_Path=$(   unzip -l CLI.zip       | awk "/dll/{print \$4;exit}" FS=' ' || exit 1) &&
     echo "CLI DLL file path geted"
Server_DLL_File_Path=$(unzip -l WEBServer.zip | awk "/dll/{print \$4;exit}" FS=' ' || exit 1) &&
     echo "WEBServer DLL file path geted"

unzip CLI.zip       "${CLI_DLL_File_Path%/*}/*"
unzip WEBServer.zip "${Server_DLL_File_Path%/*}/*"

# wget -q "https://github.com/hegugu-ng/DDTV_WEBUI/releases/latest/download/$(wget -qO - https://raw.githubusercontent.com/hegugu-ng/DDTV_WEBUI/main/.github/workflows/npm-publish-github-packages.yml | awk "/files:.*\.zip/{print \$2;exit}" FS='/')"
# wget -q https://github.com/moomiji/docker-ddtv/releases/download/edge/static.zip
# unzip static.zip -d nginx/DDTV_Backups/static
# mv -v dist/* \
#          nginx/DDTV_Backups/static

mkdir -vp debug/root                  \
          deps/root                   \
          cli/root/DDTV               \
          cli/root/DDTV_Backups       \
          webserver/root/DDTV         \
          webserver/root/DDTV_Backups \
          webui/root/DDTV             \
          webui/root/DDTV_Backups

mv -v "${CLI_DLL_File_Path%/*}"/*     \
          cli/root/DDTV_Backups
mv -v "${Server_DLL_File_Path%/*}"/*  \
          webserver/root/DDTV_Backups

echo deps/root      \
     debug/root     | xargs -n 1 cp -v ./install-deps.sh

echo cli/root       \
     Debug/root     \
     webui/root/docker-entrypoint.d/01-checkup.sh \
     webserver/root | xargs -n 1 cp -v ./checkup.sh
