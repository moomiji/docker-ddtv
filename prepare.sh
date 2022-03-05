#!/bin/bash
set -e; set -u
wget -q "https://github.com/CHKZL/DDTV/releases/latest/download/$(wget -qO - https://api.github.com/repos/CHKZL/DDTV/releases/latest | awk '/[Ss]erver/{print $4;exit}' FS='"')"
Server_File_Path=$(unzip -l ./*.zip | awk "/files:.*\.zip/{print \$2;exit}" FS='/')

#wget -q "https://github.com/hegugu-ng/DDTV_WEBUI/releases/latest/download/$(wget -qO - https://raw.githubusercontent.com/hegugu-ng/DDTV_WEBUI/main/.github/workflows/npm-publish-github-packages.yml | awk '/[Ss]erver/{print $4;exit}' FS='"')"
wget "$1"
unzip "*.zip"

mkdir -p root/DDTV root/DDTV_Backups/static nginx/usr/share/nginx/html
#cp -vur dist/* root/DDTV_Backups/static
mv -vu dist/* nginx/usr/share/nginx/html
mv -vu "${Server_File_Path%/*}"/* root/DDTV_Backups
cd root/DDTV_Backups && dotnet DDTV_Update.dll docker
