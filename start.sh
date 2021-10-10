#!/bin/sh

if [ ! -e "/NotIsFirstTimeUsing" ]; then

    CONGFIGPATH=/DDTVLiveRec
    BACKUPSPATH=/backups
    #NotFileExist
    if [ ! -s "$CONGFIGPATH/BiliUser.ini" ]; then
       cat $BACKUPSPATH/BiliUser.ini > $CONGFIGPATH/BiliUser.ini
    fi
    if [ ! -s "$CONGFIGPATH/RoomListConfig.json" ]; then
        cat $BACKUPSPATH/RoomListConfig.json > $CONGFIGPATH/RoomListConfig.json
    fi
    if [ ! -s "$CONGFIGPATH/DDTVLiveRec.dll.config" ]; then
        cat $BACKUPSPATH/DDTVLiveRec.dll.config > $CONGFIGPATH/DDTVLiveRec.dll.config
    fi

    FILEPATH=$CONGFIGPATH/static/config.js
    if [ -n "$apiUrl" ]; then
        sed -i "/apiUrl/s|: .*,|: $apiUrl,|" $FILEPATH
    fi
    if [ -n "$mount" ]; then
        sed -i "/mount/s|'.*'|'$mount'|" $FILEPATH
    fi

    FILEPATH=$CONGFIGPATH/DDTVLiveRec.dll.config
    if [ -n "$file" ]; then
        sed -i "/file/s|value=\".*\"|value=\"$file\"|" $FILEPATH
    fi
    if [ -n "$Livefile" ]; then
        sed -i "/Livefile/s|value=\".*\"|value=\"$Livefile\"|" $FILEPATH
    fi
    if [ -n "$DANMU" ]; then
        sed -i "/DANMU/s|value=\".*\"|value=\"$DANMU\"|" $FILEPATH
    fi
    if [ -n "$PlayWindowHeight" ]; then
        sed -i "/PlayWindowHeight/s|value=\".*\"|value=\"$PlayWindowHeight\"|" $FILEPATH
    fi
    if [ -n "$PlayWindowWidth" ]; then
        sed -i "/PlayWindowWidth/s|value=\".*\"|value=\"$PlayWindowWidth\"|" $FILEPATH
    fi
    if [ -n "$YouTubeResolution" ]; then
        sed -i "/YouTubeResolution/s|value=\".*\"|value=\"$YouTubeResolution\"|" $FILEPATH
    fi
    if [ -n "$RoomConfiguration" ]; then
        sed -i "/RoomConfiguration/s|value=\".*\"|value=\"$RoomConfiguration\"|" $FILEPATH
    fi
    if [ -n "$RoomTime" ]; then
        sed -i "/RoomTime/s|value=\".*\"|value=\"$RoomTime\"|" $FILEPATH
    fi
    if [ -n "$danmupost" ]; then
        sed -i "/danmupost/s|value=\".*\"|value=\"$danmupost\"|" $FILEPATH
    fi
    if [ -n "$DefaultVolume" ]; then
        sed -i "/DefaultVolume/s|value=\".*\"|value=\"$DefaultVolume\"|" $FILEPATH
    fi
    if [ -n "$Zoom" ]; then
        sed -i "/Zoom/s|value=\".*\"|value=\"$Zoom\"|" $FILEPATH
    fi
    if [ -n "$cookie" ]; then
        sed -i "/cookie/s|value=\".*\"|value=\"$cookie\"|" $FILEPATH
    fi
    if [ -n "$DT1" ]; then
        sed -i "/DT1/s|value=\".*\"|value=\"$DT1\"|" $FILEPATH
    fi
    if [ -n "$DT2" ]; then
        sed -i "/DT2/s|value=\".*\"|value=\"$DT2\"|" $FILEPATH
    fi
    if [ -n "$PlayNum" ]; then
        sed -i "/PlayNum/s|value=\".*\"|value=\"$PlayNum\"|" $FILEPATH
    fi
    if [ -n "$DanMuColor" ]; then
        sed -i "/DanMuColor/s|value=\".*\"|value=\"$DanMuColor\"|" $FILEPATH
    fi
    if [ -n "$ZiMuColor" ]; then
        sed -i "/ZiMuColor/s|value=\".*\"|value=\"$ZiMuColor\"|" $FILEPATH
    fi
    if [ -n "$DanMuSize" ]; then
        sed -i "/DanMuSize/s|value=\".*\"|value=\"$DanMuSize\"|" $FILEPATH
    fi
    if [ -n "$ZiMuSize" ]; then
        sed -i "/ZiMuSize/s|value=\".*\"|value=\"$ZiMuSize\"|" $FILEPATH
    fi
    if [ -n "$ClientSettingsProvider.ServiceUri" ]; then
        sed -i "/ClientSettingsProvider.ServiceUri/s|value=\".*\"|value=\"$ClientSettingsProvider.ServiceUri\"|" $FILEPATH
    fi
    if [ -n "$LiveListTime" ]; then
        sed -i "/LiveListTime/s|value=\".*\"|value=\"$LiveListTime\"|" $FILEPATH
    fi
    if [ -n "$PlayWindowH" ]; then
        sed -i "/PlayWindowH/s|value=\".*\"|value=\"$PlayWindowH\"|" $FILEPATH
    fi
    if [ -n "$PlayWindowW" ]; then
        sed -i "/PlayWindowW/s|value=\".*\"|value=\"$PlayWindowW\"|" $FILEPATH
    fi
    if [ -n "$BufferDuration" ]; then
        sed -i "/BufferDuration/s|value=\".*\"|value=\"$BufferDuration\"|" $FILEPATH
    fi
    if [ -n "$AutoTranscoding" ]; then
        sed -i "/AutoTranscoding/s|value=\".*\"|value=\"$AutoTranscoding\"|" $FILEPATH
    fi
    if [ -n "$ClipboardMonitoring" ]; then
        sed -i "/ClipboardMonitoring/s|value=\".*\"|value=\"$ClipboardMonitoring\"|" $FILEPATH
    fi
    if [ -n "$DataSource" ]; then
        sed -i "/DataSource/s|value=\".*\"|value=\"$DataSource\"|" $FILEPATH
    fi
    if [ -n "$IsFirstTimeUsing" ]; then
        sed -i "/IsFirstTimeUsing/s|value=\".*\"|value=\"$IsFirstTimeUsing\"|" $FILEPATH
    fi
    if [ -n "$NotVTBStatus" ]; then
        sed -i "/NotVTBStatus/s|value=\".*\"|value=\"$NotVTBStatus\"|" $FILEPATH
    fi
    if [ -n "$LiveRecWebServerDefaultIP" ]; then
        sed -i "/LiveRecWebServerDefaultIP/s|value=\".*\"|value=\"$LiveRecWebServerDefaultIP\"|" $FILEPATH
    fi
    if [ -n "$Port" ]; then
        sed -i "/Port/s|value=\".*\"|value=\"$Port\"|" $FILEPATH
    fi
    if [ -n "$RecordDanmu" ]; then
        sed -i "/RecordDanmu/s|value=\".*\"|value=\"$RecordDanmu\"|" $FILEPATH
    fi
    if [ -n "$BootUp" ]; then
        sed -i "/BootUp/s|value=\".*\"|value=\"$BootUp\"|" $FILEPATH
    fi
    if [ -n "$DebugFile" ]; then
        sed -i "/DebugFile/s|value=\".*\"|value=\"$DebugFile\"|" $FILEPATH
    fi
    if [ -n "$DebugCmd" ]; then
        sed -i "/DebugCmd/s|value=\".*\"|value=\"$DebugCmd\"|" $FILEPATH
    fi
    if [ -n "$DebugMod" ]; then
        sed -i "/DebugMod/s|value=\".*\"|value=\"$DebugMod\"|" $FILEPATH
    fi
    if [ -n "$DevelopmentModel" ]; then
        sed -i "/DevelopmentModel/s|value=\".*\"|value=\"$DevelopmentModel\"|" $FILEPATH
    fi
    if [ -n "$DokiDoki" ]; then
        sed -i "/DokiDoki/s|value=\".*\"|value=\"$DokiDoki\"|" $FILEPATH
    fi
    if [ -n "$NetStatusMonitor" ]; then
        sed -i "/NetStatusMonitor/s|value=\".*\"|value=\"$NetStatusMonitor\"|" $FILEPATH
    fi
    if [ -n "$WebAuthenticationAadminPassword" ]; then
        sed -i "/WebAuthenticationAadminPassword/s|value=\".*\"|value=\"$WebAuthenticationAadminPassword\"|" $FILEPATH
    fi
    if [ -n "$WebAuthenticationGhostPasswrod" ]; then
        sed -i "/WebAuthenticationGhostPasswrod/s|value=\".*\"|value=\"$WebAuthenticationGhostPasswrod\"|" $FILEPATH
    fi
    if [ -n "$WebAuthenticationCode" ]; then
        sed -i "/WebAuthenticationCode/s|value=\".*\"|value=\"$WebAuthenticationCode\"|" $FILEPATH
    fi
    if [ -n "$sslName" ]; then
        sed -i "/sslName/s|value=\".*\"|value=\"$sslName\"|" $FILEPATH
    fi
    if [ -n "$sslPssword" ]; then
        sed -i "/sslPssword/s|value=\".*\"|value=\"$sslPssword\"|" $FILEPATH
    fi
    if [ -n "$EnableUpload" ]; then
        sed -i "/EnableUpload/s|value=\".*\"|value=\"$EnableUpload\"|" $FILEPATH
    fi
    if [ -n "$DeleteAfterUpload" ]; then
        sed -i "/DeleteAfterUpload/s|value=\".*\"|value=\"$DeleteAfterUpload\"|" $FILEPATH
    fi
    if [ -n "$EnableOneDrive" ]; then
        sed -i "/EnableOneDrive/s|value=\".*\"|value=\"$EnableOneDrive\"|" $FILEPATH
    fi
    if [ -n "$OneDriveConfig" ]; then
        sed -i "/OneDriveConfig/s|value=\".*\"|value=\"$OneDriveConfig\"|" $FILEPATH
    fi
    if [ -n "$OneDrivePath" ]; then
        sed -i "/OneDrivePath/s|value=\".*\"|value=\"$OneDrivePath\"|" $FILEPATH
    fi
    if [ -n "$EnableCos" ]; then
        sed -i "/EnableCos/s|value=\".*\"|value=\"$EnableCos\"|" $FILEPATH
    fi
    if [ -n "$CosSecretId" ]; then
        sed -i "/CosSecretId/s|value=\".*\"|value=\"$CosSecretId\"|" $FILEPATH
    fi
    if [ -n "$CosSecretKey" ]; then
        sed -i "/CosSecretKey/s|value=\".*\"|value=\"$CosSecretKey\"|" $FILEPATH
    fi
    if [ -n "$CosRegion" ]; then
        sed -i "/CosRegion/s|value=\".*\"|value=\"$CosRegion\"|" $FILEPATH
    fi
    if [ -n "$CosBucket" ]; then
        sed -i "/CosBucket/s|value=\".*\"|value=\"$CosBucket\"|" $FILEPATH
    fi
    if [ -n "$CosPath" ]; then
        sed -i "/CosPath/s|value=\".*\"|value=\"$CosPath\"|" $FILEPATH
    fi
    if [ -n "$EnableBaiduPan" ]; then
        sed -i "/EnableBaiduPan/s|value=\".*\"|value=\"$EnableBaiduPan\"|" $FILEPATH
    fi
    if [ -n "$BaiduPanPath" ]; then
        sed -i "/BaiduPanPath/s|value=\".*\"|value=\"$BaiduPanPath\"|" $FILEPATH
    fi
    if [ -n "$EnableOss" ]; then
        sed -i "/EnableOss/s|value=\".*\"|value=\"$EnableOss\"|" $FILEPATH
    fi
    if [ -n "$OssAccessKeyId" ]; then
        sed -i "/OssAccessKeyId/s|value=\".*\"|value=\"$OssAccessKeyId\"|" $FILEPATH
    fi
    if [ -n "$OssAccessKeySecret" ]; then
        sed -i "/OssAccessKeySecret/s|value=\".*\"|value=\"$OssAccessKeySecret\"|" $FILEPATH
    fi
    if [ -n "$OssEndpoint" ]; then
        sed -i "/OssEndpoint/s|value=\".*\"|value=\"$OssEndpoint\"|" $FILEPATH
    fi
    if [ -n "$OssBucketName" ]; then
        sed -i "/OssBucketName/s|value=\".*\"|value=\"$OssBucketName\"|" $FILEPATH
    fi
    if [ -n "$OssPath" ]; then
        sed -i "/OssPath/s|value=\".*\"|value=\"$OssPath\"|" $FILEPATH
    fi
    if [ -n "$AutoTranscodingDelFile" ]; then
        sed -i "/AutoTranscodingDelFile/s|value=\".*\"|value=\"$AutoTranscodingDelFile\"|" $FILEPATH
    fi
    if [ -n "$ServerName" ]; then
        sed -i "/ServerName/s|value=\".*\"|value=\"$ServerName\"|" $FILEPATH
    fi
    if [ -n "$ServerAID" ]; then
        sed -i "/ServerAID/s|value=\".*\"|value=\"$ServerAID\"|" $FILEPATH
    fi
    if [ -n "$ServerGroup" ]; then
        sed -i "/ServerGroup/s|value=\".*\"|value=\"$ServerGroup\"|" $FILEPATH
    fi
    if [ -n "$ApiToken" ]; then
        sed -i "/ApiToken/s|value=\".*\"|value=\"$ApiToken\"|" $FILEPATH
    fi
    if [ -n "$WebUserName" ]; then
        sed -i "/WebUserName/s|value=\".*\"|value=\"$WebUserName\"|" $FILEPATH
    fi
    if [ -n "$WebPassword" ]; then
        sed -i "/WebPassword/s|value=\".*\"|value=\"$WebPassword\"|" $FILEPATH
    fi
    if [ -n "$WebhookUrl" ]; then
        sed -i "/WebhookUrl/s|value=\".*\"|value=\"$WebhookUrl\"|" $FILEPATH
    fi
    if [ -n "$WebhookEnable" ]; then
        sed -i "/WebhookEnable/s|value=\".*\"|value=\"$WebhookEnable\"|" $FILEPATH
    fi
    if [ -n "$WebSocketPort" ]; then
        sed -i "/WebSocketPort/s|value=\".*\"|value=\"$WebSocketPort\"|" $FILEPATH
    fi
    if [ -n "$WebSocketEnable" ]; then
        sed -i "/WebSocketEnable/s|value=\".*\"|value=\"$WebSocketEnable\"|" $FILEPATH
    fi
    if [ -n "$WebSocketUserName" ]; then
        sed -i "/WebSocketUserName/s|value=\".*\"|value=\"$WebSocketUserName\"|" $FILEPATH
    fi
    if [ -n "$WebSocketPassword" ]; then
        sed -i "/WebSocketPassword/s|value=\".*\"|value=\"$WebSocketPassword\"|" $FILEPATH
    fi
    if [ -n "$DefaultFileName" ]; then
        sed -i "/DefaultFileName/s|value=\".*\"|value=\"$DefaultFileName\"|" $FILEPATH
    fi

    touch /NotIsFirstTimeUsing
fi

chown -R $PUID:$PGID /DDTVLiveRec $CONGFIGPATH
echo Running as PID $PUID and GID $PGID.

OSRELEASE=`awk -F= '/^ID=/{print $2}' /etc/os-release`
if [ "$OSRELEASE" = "debian" ]; then
    gosu $PUID:$PGID dotnet DDTVLiveRec.dll
elif [ "$OSRELEASE" = "alpine" ]; then
    su-exec $PUID:$PGID dotnet DDTVLiveRec.dll
else
    echo "未支持$OSRELEASE"
fi
