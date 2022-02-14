#!/bin/bash
Tmp_File=DDTV_Tmp
Backups_Path=/DDTV_Backups
Download_Url=$(wget -qO - https://api.github.com/repos/CHKZL/DDTV/releases/latest | awk '/\/DDTV_W/{print $4;exit}' FS='"')
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

echo "**** install DDTV ****"
    wget $Download_Url -O $Tmp_File.zip
    unzip $Tmp_File.zip -d $Tmp_File
    File_Path=$(unzip -l $Tmp_File.zip | awk "/dll/{print \$4;exit}" FS=' ')
    File_Path=${File_Path%/*}
    mkdir $Backups_Path
    mv -f $Tmp_File/$File_Path/* $Backups_Path

echo "**** clean up ****"
    rm -rf $Tmp_File*
