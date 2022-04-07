#!/bin/bash
set -e; set -u

# 复用 Dockerfile
shopt -s globstar nullglob
for Dockerfile in ./**/Dockerfile; do
    cp "$Dockerfile" "$Dockerfile".alpine
    sed -i 'N;1a-alpine' "$Dockerfile".alpine
done

# 下载 DDTV

wget -q https://api.github.com/repos/CHKZL/DDTV/releases/latest
wget -q -O CLI.zip "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i CLI)"
wget -q -O WEBServer.zip "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i Server)"
CLI_File_Path=$(   unzip -l CLI.zip       | awk "/dll/{print \$4;exit}" FS=' ')
Server_File_Path=$(unzip -l WEBserver.zip | awk "/dll/{print \$4;exit}" FS=' ')
unzip CLI.zip WEBserver.zip

# wget -q "https://github.com/hegugu-ng/DDTV_WEBUI/releases/latest/download/$(wget -qO - https://raw.githubusercontent.com/hegugu-ng/DDTV_WEBUI/main/.github/workflows/npm-publish-github-packages.yml | awk "/files:.*\.zip/{print \$2;exit}" FS='/')"
# wget -q https://github.com/moomiji/docker-ddtv/releases/download/edge/static.zip
# unzip static.zip -d nginx/DDTV_Backups/static
# mv -v dist/* \
#          nginx/DDTV_Backups/static

# cd "${Server_File_Path%/*}/" && dotnet DDTV_Update.dll docker && cd -

mkdir -p Debug/root \
         CLI/root/DDTV \
         CLI/root/DDTV_Backups \
         WEBServer/root/DDTV \
         WEBServer/root/DDTV_Backups \
         WEBUI/root/DDTV \
         WEBUI/root/DDTV_Backups

mv -v "${CLI_File_Path%/*}/*" \
         CLI/root/DDTV_Backups
mv -v "${Server_File_Path%/*}/*" \
         WEBServer/root/DDTV_Backups

echo CLI/            \
     Debug/          \
     WEBUI/          \
     WEBServer/      | xargs -n 1 cp -v ./install.sh

echo CLI/root/       \
     Debug/root/     \
     WEBUI/root/     \
     WEBServer/root/ | xargs -n 1 cp -v ./checkup.sh
