#!/bin/bash
set -e; set -u

# 复用 Dockerfile
shopt -s globstar nullglob
for Dockerfile in ./**/Dockerfile; do
    cp "$Dockerfile" "$Dockerfile".alpine
    sed -i '/FROM/s/$/&-alpine/g' "$Dockerfile".alpine
done

# 下载 DDTV

wget -q https://api.github.com/repos/CHKZL/DDTV/releases/latest &&
    echo "latest downloaded"
wget -q -O CLI.zip "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i CLI)" &&
    echo "CLI.zip downloaded"
wget -q -O WEBServer.zip "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i Server)" &&
    echo "WEBServer.zip downloaded"
CLI_DLL_File_Path=$(   unzip -l CLI.zip       | awk "/dll/{print \$4;exit}" FS=' ') &&
    echo "CLI DLL file path geted"
Server_DLL_File_Path=$(unzip -l WEBServer.zip | awk "/dll/{print \$4;exit}" FS=' ') &&
    echo "WEBServer DLL file path geted"
unzip CLI.zip "${CLI_DLL_File_Path%/*}/*"
unzip WEBServer.zip "${Server_DLL_File_Path%/*}/*"

# wget -q "https://github.com/hegugu-ng/DDTV_WEBUI/releases/latest/download/$(wget -qO - https://raw.githubusercontent.com/hegugu-ng/DDTV_WEBUI/main/.github/workflows/npm-publish-github-packages.yml | awk "/files:.*\.zip/{print \$2;exit}" FS='/')"
# wget -q https://github.com/moomiji/docker-ddtv/releases/download/edge/static.zip
# unzip static.zip -d nginx/DDTV_Backups/static
# mv -v dist/* \
#          nginx/DDTV_Backups/static

# cd "${Server_DLL_File_Path%/*}/" && dotnet DDTV_Update.dll docker && cd -

mkdir -vp Deps/root                   \
          Debug/root                  \
          CLI/root/DDTV               \
          CLI/root/DDTV_Backups       \
          WEBServer/root/DDTV         \
          WEBServer/root/DDTV_Backups \
          WEBUI/root/DDTV             \
          WEBUI/root/DDTV_Backups

mv -v "${CLI_DLL_File_Path%/*}"/*     \
          CLI/root/DDTV_Backups
mv -v "${Server_DLL_File_Path%/*}"/*  \
          WEBServer/root/DDTV_Backups

echo Deps/root      \
     Debug/root     | xargs -n 1 cp -v ./install-Deps.sh

echo CLI/root       \
     Debug/root     \
     WEBUI/root/docker-entrypoint.d/01-checkup.sh \
     WEBServer/root | xargs -n 1 cp -v ./checkup.sh
