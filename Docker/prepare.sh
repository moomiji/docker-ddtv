#!/bin/bash
set -e; set -u
wget "https://github.com/CHKZL/DDTV/releases/latest/download/$(wget -qO - https://api.github.com/repos/CHKZL/DDTV/releases/latest | awk '/[Ss]erver/{print $4;exit}' FS='"')"
File_Path=$(unzip -l *.zip | awk "/dll/{print \$4;exit}" FS=' ')
unzip *.zip
mkdir root/DDTV root/DDTV_Backups
mv -f ${File_Path%/*}/* root/DDTV_Backups
cd root/DDTV_Backups && dotnet DDTV_Update.dll docker
