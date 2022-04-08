#!/bin/bash
# 在CLI WEBServer WEBUI (Debug) 启动之前，检查文件
# 参数更新需修改 README.md docker-compose.yml
set -e; set -u

DDTV_Path=/DDTV
Backups_Path=/DDTV_Backups
WEBUI_Config_Path=${WEBUI_Path:-/DDTV}/static
RoomListConfig_Path=${RoomListConfig_Path:-"$DDTV_Path/RoomListConfig.json"}

checkup() {
    case ${DDTV_Project:-WTF} in
        Debug)
            check_tool_Debug
            ;;
        CLI)
            check_dir_DDTV
            check_file_BiliUser_ini
            check_file_DDTV_Config_ini
            check_file_RoomListConfig_json
            ;;
        WEBServer)
            check_dir_DDTV
            #if [ ! -e "/NotIsFirstStart" ]; then
            #    check_file_config_js
            #    check_file_barinfo_js
            #fi
            check_file_BiliUser_ini
            check_file_DDTV_Config_ini
            check_file_RoomListConfig_json
            ;;
        WEBUI)
            check_dir_DDTV
            if [ ! -e "/NotIsFirstStart" ]; then
                check_file_config_js
                check_file_barinfo_js
            fi
            ;;
        *)
            echo "Error DDTV Project!" && exit 1
            ;;
    esac
        touch /NotIsFirstStart
}

# 检测 DDTV 目录文件是否齐全
check_dir_DDTV() {
    cd "$DDTV_Path" || exit
    if [ "$(ls -A "$Backups_Path")" ]; then
        shopt -s globstar nullglob
        for file in "$Backups_Path"/**; do
            [ "${file##"$Backups_Path"/}" = "" ] && continue
            [ ! -e "${file##"$Backups_Path"/}" ] && cp -vur "$file" "${file##"$Backups_Path"/}"
        done
    fi
}

# 写入 RoomListConfig.json
# 可用参数有:
#   $RoomListConfig_Path
#   $RoomList
check_file_RoomListConfig_json() {
    File_Path=$RoomListConfig_Path
    if [ ! -e "$File_Path" ]; then
        if [ -n "${RoomList:-}" ]; then
            echo "$RoomList" > "$File_Path" && echo "Writed in $File_Path: $RoomList"
        fi
    fi
}

# 写入 BiliUser.ini
# 可用参数有: 
#   $BiliUser
check_file_BiliUser_ini() {
    File_Path=$DDTV_Path/BiliUser.ini
    if [ ! -e "$File_Path" ]; then
        if [ -n "${BiliUser:-}" ]; then
            echo -e "$BiliUser" > $File_Path && echo -e "Writed in $File_Path: $BiliUser"
        fi
    fi
}

# 写入 DDTV_Config.ini
# 可用参数有:
#   $RoomListConfig_Path
#   $arg_name 
#       e.g. ${arg_name:+"arg_name=$arg_name"}
check_file_DDTV_Config_ini() {
    File_Path=$DDTV_Path/DDTV_Config.ini
    if [ ! -e "$File_Path" ]; then
        echo "
[Core]
RoomListConfig=$RoomListConfig_Path
${TranscodParmetrs:+"TranscodParmetrs=$TranscodParmetrs"}
${IsAutoTranscod:+"IsAutoTranscod=$IsAutoTranscod"}
${GUI_FirstStart:+"GUI_FirstStart=$GUI_FirstStart"}
${WEB_FirstStart:+"WEB_FirstStart=$WEB_FirstStart"}
${ClientAID:+"ClientAID=$ClientAID"}
[Download]
${DownloadPath:+"DownloadPath=$DownloadPath"}
${TmpPath:+"TmpPath=$TmpPath"}
${DownloadDirectoryName:+"DownloadDirectoryName=$DownloadDirectoryName"}
${DownloadFileName:+"DownloadFileName=$DownloadFileName"}
${RecQuality:+"RecQuality=$RecQuality"}
${IsRecDanmu:+"IsRecDanmu=$IsRecDanmu"}
${IsRecGift:+"IsRecGift=$IsRecGift"}
${IsRecGuard:+"IsRecGuard=$IsRecGuard"}
${IsRecSC:+"IsRecSC=$IsRecSC"}
${IsFlvSplit:+"IsFlvSplit=$IsFlvSplit"}
${FlvSplitSize:+"FlvSplitSize=$FlvSplitSize"}
${DoNotSleepWhileDownloading:+"DoNotSleepWhileDownloading=$DoNotSleepWhileDownloading"}
${Shell:+"Shell=$Shell"}
[WEB_API]
${WEB_API_SSL:+"WEB_API_SSL=$WEB_API_SSL"}
${pfxFileName:+"pfxFileName=$pfxFileName"}
${pfxPasswordFileName:+"pfxPasswordFileName=$pfxPasswordFileName"}
${WebUserName:+"WebUserName=$WebUserName"}
${WebPassword:+"WebPassword=$WebPassword"}
${AccessKeyId:+"AccessKeyId=$AccessKeyId"}
${AccessKeySecret:+"AccessKeySecret=$AccessKeySecret"}
${ServerAID:+"ServerAID=$ServerAID"}
${ServerName:+"ServerName=$ServerName"}
${AccessControlAllowOrigin:+"AccessControlAllowOrigin=$AccessControlAllowOrigin"}
${AccessControlAllowCredentials:+"AccessControlAllowCredentials=$AccessControlAllowCredentials"}
${CookieDomain:+"CookieDomain=$CookieDomain"}
" > "$File_Path" && echo "Writed in $File_Path:" && awk NF "$File_Path"
    fi
    # 22.04.07 更新至Shell 新增 3 个
    # 34-3 个键值 DefaultVolume PlayQuality HideIconState
}

# 第一次启动 DDTV Debug 
check_tool_Debug() {
    dotnet tool install --tool-path /tools \
        dotnet-counters \
        dotnet-coverage \
        dotnet-dump \
        dotnet-gcdump \
        dotnet-trace \
        dotnet-stack \
        dotnet-symbol \
        dotnet-sos
}

# 第一次启动配置前端文件config.js
check_file_config_js() {
    File_Path=$WEBUI_Config_Path/config.js
    if [ -n "$apiUrl" ]; then
        if [[ "$apiUrl" == "false" ]]; then
            sed -i "/apiUrl/s|:.*,|: $apiUrl,|"     "$File_Path"
        else
            sed -i "/apiUrl/s|:.*,|: \"$apiUrl\",|" "$File_Path"
        fi
    fi
    if [ -n "$mount" ]; then
        sed -i "/mount/s|'.*'|'$mount'|" "$File_Path"
    fi
    echo "Writed in $File_Path:"
    cat "$File_Path"
}

# 第一次启动配置前端文件barinfo.js
check_file_barinfo_js() {
    File_Path=$WEBUI_Config_Path/barinfo.js
    if [ -n "$show"     ]; then
        sed -i "/    show/s|: .*,|: $show,|"                         "$File_Path" ; fi
    if [ -n "$infoshow" ]; then
        sed -i "/info.*show/s|show:.*text|show: $infotext, text|"    "$File_Path" ; fi
    if [ -n "$infotext" ]; then
        sed -i "/info.*text/s|text.*link|text: \"$infotext\", link|" "$File_Path" ; fi
    if [ -n "$infolink" ]; then
        sed -i "/info.*link/s|link.*}|link: \"$infolink\" }|"        "$File_Path" ; fi
    if [ -n "$ICPshow"  ]; then
        sed -i "/ICP.*show/s|show.*text|show: $ICPshow, text|"       "$File_Path" ; fi
    if [ -n "$ICPtext"  ]; then
        sed -i "/ICP.*show/s|text.*link|show: \"$ICPtext\", link|"   "$File_Path" ; fi
    if [ -n "$ICPlink"  ]; then
        sed -i "/ICP.*link/s|link.*}|link: \"$ICPlink\" }|"          "$File_Path" ; fi
    if [ -n "$GAshow"   ]; then
        sed -i "/GA.*show/s|show.*text|show: $GAshow, text|"         "$File_Path" ; fi
    if [ -n "$GAtext"   ]; then
        sed -i "/GA.*show/s|text.*link|show: \"$GAtext\", link|"     "$File_Path" ; fi
    if [ -n "$GAlink"   ]; then
        sed -i "/GA.*link/s|link.*}|link: \"$GAlink\" }|"            "$File_Path" ; fi
    echo "Writed in $File_Path:"
    cat "$File_Path"
}

checkup