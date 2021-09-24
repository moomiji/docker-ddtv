#!/bin/sh
WORKPATH=/DDTVLiveRec
BACKUPSPATH=/backups
RMFILENAME=ReleaseInstalled
DDTVLiveRecVERSION=` wget -qO - https://api.github.com/repos/CHKZL/DDTV2/releases/latest | awk '/tag_name/{print $5;exit}' FS='[r"]' `

echo "**** install DDTVLiveRec ****"
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
    wget https://github.com/CHKZL/DDTV2/releases/latest/download/DDTVLiveRec-${DDTVLiveRecVERSION}.zip -O $RMFILENAME.zip
    unzip $RMFILENAME.zip -d $RMFILENAME
    mv $RMFILENAME/*/*/* $WORKPATH

echo "**** prepare for start.sh ****"
    mkdir $BACKUPSPATH
    mv $WORKPATH/DDTVLiveRec.dll.config $BACKUPSPATH/DDTVLiveRec.dll.config
    mv $RMFILENAME/*/*RoomListConfig.json $BACKUPSPATH/RoomListConfig.json
    echo -e "[User]\n\nCookie=\ncsrf=" > $BACKUPSPATH/BiliUser.ini
    sed -i '1c [User]' $BACKUPSPATH/BiliUser.ini

echo "**** clean up ****"
    rm -rf $RMFILENAME*
