#!/bin/bash
echo '           ____  ____  _______    __   _____  ____
          / __ \/ __ \/_  __/ |  / /  |__  / / __ \
         / / / / / / / / /  | | / /    /_ < / / / /
        / /_/ / /_/ / / /   | |/ /   ___/ // /_/ /
       /_____/_____/ /_/    |___/   /____(_)____/

 _       ____________     _____
| |     / / ____/ __ )   / ___/___  ______   _____  _____
| | /| / / __/ / __  |   \__ \/ _ \/ ___/ | / / _ \/ ___/
| |/ |/ / /___/ /_/ /   ___/ /  __/ /   | |/ /  __/ /
|__/|__/_____/_____/   /____/\___/_/    |___/\___/_/
'
echo ""
echo "Running as PID ${PUID:=$UID} and GID ${PGID:=$PUID}."
echo ""

Backups_Path=/DDTV_Backups
DDTV_Config=${DDTV_Config:-"./DDTV_Config.ini"}
RoomListConfig=${RoomListConfig:-"./RoomListConfig.json"}

if [ "$(ls -A $Backups_Path)" ]; then
    for i in $Backups_Path/*; do
        [ ! -e ${i##*/} ] && cp -vur $i ${i##*/}
    done
fi

if [ ! -e "$RoomListConfig" ]; then
    if [ -n $roomlist ]; then
        echo $roomlist > $RoomListConfig
    fi
fi

if [ ! -e "$DDTV_Config" ]; then
echo "[Core]
RoomListConfig=$RoomListConfig
GUI_FirstStart=true
WEB_FirstStart=true
${TranscodParmetrs:+TranscodParmetrs=$TranscodParmetrs}
${IsAutoTranscod:+IsAutoTranscod=$IsAutoTranscod}
${ClientAID:+ClientAID=$ClientAID}
[Download]
${DownloadPath:+DownloadPath=$DownloadPath}
${TmpPath:+TmpPath=$TmpPath}
${DownloadDirectoryName:+DownloadDirectoryName=$DownloadDirectoryName}
${DownloadFileName:+DownloadFileName=$DownloadFileName}
${RecQuality:+RecQuality=$RecQuality}
${IsRecDanmu:+IsRecDanmu=$IsRecDanmu}
${IsRecGift:+IsRecGift=$IsRecGift}
${IsRecGuard:+IsRecGuard=$IsRecGuard}
${IsRecSC:+IsRecSC=$IsRecSC}
${IsFlvSplit:+IsFlvSplit=$IsFlvSplit}
${FlvSplitSize:+FlvSplitSize=$FlvSplitSize}
[WEB_API]
${WEB_API_SSL:+WEB_API_SSL=$WEB_API_SSL}
${pfxFileName:+pfxFileName=$pfxFileName}
${pfxPasswordFileName:+pfxPasswordFileName=$pfxPasswordFileName}
${WebUserName:+WebUserName=$WebUserName}
${WebPassword:+WebPassword=$WebPassword}
${AccessKeyId:+AccessKeyId=$AccessKeyId}
${AccessKeySecret:+AccessKeySecret=$AccessKeySecret}
${ServerAID:+ServerAID=$ServerAID}
${ServerName:+ServerName=$ServerName}" > $DDTV_Config
fi

ID=`awk -F= '/^ID=/{print $2}' /etc/os-release`
dotnet DDTV_Update.dll docker

chown -R $PUID:$PGID /DDTV $DownloadPath $TmpPath
if [ "$ID" = "debian" ]; then
    gosu $PUID:$PGID dotnet DDTV_WEB_Server.dll
elif [ "$ID" = "alpine" ]; then
    su-exec $PUID:$PGID dotnet DDTV_WEB_Server.dll
else
    echo "未支持$ID"
fi
