#!/bin/bash
set -e; set -u
wget -q "https://github.com/CHKZL/DDTV/releases/latest/download/$(wget -qO - https://api.github.com/repos/CHKZL/DDTV/releases/latest | awk '/[Ss]erver/{print $4;exit}' FS='"')"
Server_File_Path=$(unzip -l ./*.zip | awk "/dll/{print \$4;exit}" FS=' ')

#wget -q "https://github.com/hegugu-ng/DDTV_WEBUI/releases/latest/download/$(wget -qO - https://raw.githubusercontent.com/hegugu-ng/DDTV_WEBUI/main/.github/workflows/npm-publish-github-packages.yml | awk "/files:.*\.zip/{print \$2;exit}" FS='/')"
wget "$1"
unzip "*.zip"

mkdir -p root/DDTV \
         root/DDTV_Backups \
         nginx/DDTV_Backups
mv -v dist/* nginx/DDTV_Backups
mv -v "${Server_File_Path%/*}"/* root/DDTV_Backups
cp -v nginx/docker-entrypoint.d/webui.sh root/webui.sh
cd root/DDTV_Backups && dotnet DDTV_Update.dll docker
