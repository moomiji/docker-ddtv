#!/bin/bash
set -e; set -u
# 当前可用参数有：--no-update
# 参数更新需修改start.sh README.md docker-compose.yml
ARGs=${*:-"--no-arguments"}
# 测试用
if [[ "$ARGs" != "--"* ]]; then echo "exec $ARGs"; eval "$ARGs"; exit $?; fi

# 运行 webui.sh
# 检测 DDTV 目录文件是否齐全
./webui.sh

echo '
 _       ____________     _____
| |     / / ____/ __ )   / ___/___  ______   _____  _____
| | /| / / __/ / __  |   \__ \/ _ \/ ___/ | / / _ \/ ___/
| |/ |/ / /___/ /_/ /   ___/ /  __/ /   | |/ /  __/ /
|__/|__/_____/_____/   /____/\___/_/    |___/\___/_/
'
echo "Running as UID ${PUID:=$UID} and GID ${PGID:=$PUID}."
echo ""
cd /DDTV || exit

BiliUser_Path=./BiliUser.ini
DDTV_Config_Path=./DDTV_Config.ini
RoomListConfig_Path=${RoomListConfig_Path:-"./RoomListConfig.json"}

# 写入 RoomListConfig.json
if [ ! -e "$RoomListConfig_Path" ]; then
    if [ -n "${RoomList:-}" ]; then
        echo "$RoomList" > "$RoomListConfig_Path"
    fi
fi

# 写入 BiliUser.ini
if [ ! -e "$BiliUser_Path" ]; then
    if [ -n "${BiliUser:-}" ]; then
        echo -e "$BiliUser" > $BiliUser_Path
    fi
fi

# 写入 DDTV_Config.ini
if [ ! -e "$DDTV_Config_Path" ]; then
echo "[Core]
RoomListConfig=$RoomListConfig_Path
${GUI_FirstStart:+GUI_FirstStart=$GUI_FirstStart}
${WEB_FirstStart:+WEB_FirstStart=$WEB_FirstStart}
${IsAutoTranscod:+IsAutoTranscod=$IsAutoTranscod}
${TranscodParmetrs:+TranscodParmetrs=$TranscodParmetrs}
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
${ServerName:+ServerName=$ServerName}
${AccessControlAllowOrigin:+AccessControlAllowOrigin=$AccessControlAllowOrigin}
${AccessControlAllowCredentials:+AccessControlAllowCredentials=$AccessControlAllowCredentials}
" > "$DDTV_Config_Path"
fi # 22.03.06 更新至AccessControlAllowCredentials

# 更新 DDTV
if [[ "$ARGs" != *"--no-update"* ]]; then
    dotnet DDTV_Update.dll docker
fi

# 运行 DDTV
./etc/os-release
chown -R $PUID:$PGID /DDTV "${DownloadPath:-}" "${TmpPath:-}"

if [[ "$ID" == "debian" ]]; then
    gosu $PUID:$PGID dotnet DDTV_WEB_Server.dll
elif [[ "$ID" == "alpine" ]]; then
    su-exec $PUID:$PGID dotnet DDTV_WEB_Server.dll
else
    echo "未支持$ID" && exit 1
fi
