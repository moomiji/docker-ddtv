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
        sed -i "/apiUrl/s/false/$apiUrl/" $FILEPATH
    fi
    if [ -n "$mount" ]; then
        sed -i "/mount/s/\//$mount/" $FILEPATH
    fi

    FILEPATH=$CONGFIGPATH/DDTVLiveRec.dll.config
    if [ -n "$file" ]; then
        sed -i "/file/s/.\/tmp\//$file/" $FILEPATH
    fi
    if [ -n "$Livefile" ]; then
        sed -i "/Livefile/s/.\/tmp\/LiveCache\//$Livefile/" $FILEPATH
    fi
    if [ -n "$DANMU" ]; then
        sed -i "/DANMU/s/0/$DANMU/" $FILEPATH
    fi
    if [ -n "$PlayWindowHeight" ]; then
        sed -i "/PlayWindowHeight/s/440/$PlayWindowHeight/" $FILEPATH
    fi
    if [ -n "$PlayWindowWidth" ]; then
        sed -i "/PlayWindowWidth/s/720/$PlayWindowWidth/" $FILEPATH
    fi
    if [ -n "$YouTubeResolution" ]; then
        sed -i "/YouTubeResolution/s/640x360/$YouTubeResolution/" $FILEPATH
    fi
    if [ -n "$RoomConfiguration" ]; then
        sed -i "/RoomConfiguration/s/.\/RoomListConfig.json/$RoomConfiguration/" $FILEPATH
    fi
    if [ -n "$RoomTime" ]; then
        sed -i "/RoomTime/s/40/$RoomTime/" $FILEPATH
    fi
    if [ -n "$danmupost" ]; then
        sed -i "/danmupost/s/0/$danmupost/" $FILEPATH
    fi
    if [ -n "$DefaultVolume" ]; then
        sed -i "/DefaultVolume/s/100/$DefaultVolume/" $FILEPATH
    fi
    if [ -n "$Zoom" ]; then
        sed -i "/Zoom/s/1/$Zoom/" $FILEPATH
    fi
    if [ -n "$cookie" ]; then
        sed -i "/cookie/s/\"\"/\"$cookie\"/" $FILEPATH
    fi
    if [ -n "$DT1" ]; then
        sed -i "/DT1/s/0/$DT1/" $FILEPATH
    fi
    if [ -n "$DT2" ]; then
        sed -i "/DT2/s/0/$DT2/" $FILEPATH
    fi
    if [ -n "$PlayNum" ]; then
        sed -i "/PlayNum/s/5/$PlayNum/" $FILEPATH
    fi
    if [ -n "$DanMuColor" ]; then
        sed -i "/DanMuColor/s/0xFF,0x00,0x00,0x00/$DanMuColor/" $FILEPATH
    fi
    if [ -n "$ZiMuColor" ]; then
        sed -i "/ZiMuColor/s/0xFF,0x00,0x00,0x00/$ZiMuColor/" $FILEPATH
    fi
    if [ -n "$DanMuSize" ]; then
        sed -i "/DanMuSize/s/20/$DanMuSize/" $FILEPATH
    fi
    if [ -n "$ZiMuSize" ]; then
        sed -i "/ZiMuSize/s/24/$ZiMuSize/" $FILEPATH
    fi
    if [ -n "$ClientSettingsProvider.ServiceUri" ]; then
        sed -i "/ClientSettingsProvider.ServiceUri/s/\"\"/\"$ClientSettingsProvider.ServiceUri\"/" $FILEPATH
    fi
    if [ -n "$LiveListTime" ]; then
        sed -i "/LiveListTime/s/5/$LiveListTime/" $FILEPATH
    fi
    if [ -n "$PlayWindowH" ]; then
        sed -i "/PlayWindowH/s/450/$PlayWindowH/" $FILEPATH
    fi
    if [ -n "$PlayWindowW" ]; then
        sed -i "/PlayWindowW/s/800/$PlayWindowW/" $FILEPATH
    fi
    if [ -n "$BufferDuration" ]; then
        sed -i "/BufferDuration/s/3/$BufferDuration/" $FILEPATH
    fi
    if [ -n "$AutoTranscoding" ]; then
        sed -i "/AutoTranscoding/s/0/$AutoTranscoding/" $FILEPATH
    fi
    if [ -n "$ClipboardMonitoring" ]; then
        sed -i "/ClipboardMonitoring/s/0/$ClipboardMonitoring/" $FILEPATH
    fi
    if [ -n "$DataSource" ]; then
        sed -i "/DataSource/s/0/$DataSource/" $FILEPATH
    fi
    if [ -n "$IsFirstTimeUsing" ]; then
        sed -i "/IsFirstTimeUsing/s/1/$IsFirstTimeUsing/" $FILEPATH
    fi
    if [ -n "$NotVTBStatus" ]; then
        sed -i "/NotVTBStatus/s/0/$NotVTBStatus/" $FILEPATH
    fi
    if [ -n "$LiveRecWebServerDefaultIP" ]; then
        sed -i "/LiveRecWebServerDefaultIP/s/0.0.0.0/$LiveRecWebServerDefaultIP/" $FILEPATH
    fi
    if [ -n "$Port" ]; then
        sed -i "/Port/s/11419/$Port/" $FILEPATH
    fi
    if [ -n "$RecordDanmu" ]; then
        sed -i "/RecordDanmu/s/0/$RecordDanmu/" $FILEPATH
    fi
    if [ -n "$BootUp" ]; then
        sed -i "/BootUp/s/0/$BootUp/" $FILEPATH
    fi
    if [ -n "$DebugFile" ]; then
        sed -i "/DebugFile/s/1/$DebugFile/" $FILEPATH
    fi
    if [ -n "$DebugCmd" ]; then
        sed -i "/DebugCmd/s/1/$DebugCmd/" $FILEPATH
    fi
    if [ -n "$DebugMod" ]; then
        sed -i "/DebugMod/s/1/$DebugMod/" $FILEPATH
    fi
    if [ -n "$DevelopmentModel" ]; then
        sed -i "/DevelopmentModel/s/0/$DevelopmentModel/" $FILEPATH
    fi
    if [ -n "$DokiDoki" ]; then
        sed -i "/DokiDoki/s/300/$DokiDoki/" $FILEPATH
    fi
    if [ -n "$NetStatusMonitor" ]; then
        sed -i "/NetStatusMonitor/s/0/$NetStatusMonitor/" $FILEPATH
    fi
    if [ -n "$WebAuthenticationAadminPassword" ]; then
        sed -i "/WebAuthenticationAadminPassword/s/admin/$WebAuthenticationAadminPassword/" $FILEPATH
    fi
    if [ -n "$WebAuthenticationGhostPasswrod" ]; then
        sed -i "/WebAuthenticationGhostPasswrod/s/ghost/$WebAuthenticationGhostPasswrod/" $FILEPATH
    fi
    if [ -n "$WebAuthenticationCode" ]; then
        sed -i "/WebAuthenticationCode/s/DDTVLiveRec/$WebAuthenticationCode/" $FILEPATH
    fi
    if [ -n "$sslName" ]; then
        sed -i "/sslName/s/\"\"/\"$sslName\"/" $FILEPATH
    fi
    if [ -n "$sslPssword" ]; then
        sed -i "/sslPssword/s/\"\"/\"$sslPssword\"/" $FILEPATH
    fi
    if [ -n "$EnableUpload" ]; then
        sed -i "/EnableUpload/s/0/$EnableUpload/" $FILEPATH
    fi
    if [ -n "$DeleteAfterUpload" ]; then
        sed -i "/DeleteAfterUpload/s/1/$DeleteAfterUpload/" $FILEPATH
    fi
    if [ -n "$EnableOneDrive" ]; then
        sed -i "/EnableOneDrive/s/0/$EnableOneDrive/" $FILEPATH
    fi
    if [ -n "$OneDriveConfig" ]; then
        sed -i "/OneDriveConfig/s/\"\"/\"$OneDriveConfig\"/" $FILEPATH
    fi
    if [ -n "$OneDrivePath" ]; then
        sed -i "/OneDrivePath/s/\"\"/\"$OneDrivePath\"/" $FILEPATH
    fi
    if [ -n "$EnableCos" ]; then
        sed -i "/EnableCos/s/0/$EnableCos/" $FILEPATH
    fi
    if [ -n "$CosSecretId" ]; then
        sed -i "/CosSecretId/s/\"\"/\"$CosSecretId\"/" $FILEPATH
    fi
    if [ -n "$CosSecretKey" ]; then
        sed -i "/CosSecretKey/s/\"\"/\"$CosSecretKey\"/" $FILEPATH
    fi
    if [ -n "$CosRegion" ]; then
        sed -i "/CosRegion/s/\"\"/\"$CosRegion\"/" $FILEPATH
    fi
    if [ -n "$CosBucket" ]; then
        sed -i "/CosBucket/s/\"\"/\"$CosBucket\"/" $FILEPATH
    fi
    if [ -n "$CosPath" ]; then
        sed -i "/CosPath/s/\"\"/\"$CosPath\"/" $FILEPATH
    fi
    if [ -n "$EnableBaiduPan" ]; then
        sed -i "/EnableBaiduPan/s/0/$EnableBaiduPan/" $FILEPATH
    fi
    if [ -n "$BaiduPanPath" ]; then
        sed -i "/BaiduPanPath/s/\"\"/\"$BaiduPanPath\"/" $FILEPATH
    fi
    if [ -n "$EnableOss" ]; then
        sed -i "/EnableOss/s/0/$EnableOss/" $FILEPATH
    fi
    if [ -n "$OssAccessKeyId" ]; then
        sed -i "/OssAccessKeyId/s/\"\"/\"$OssAccessKeyId\"/" $FILEPATH
    fi
    if [ -n "$OssAccessKeySecret" ]; then
        sed -i "/OssAccessKeySecret/s/\"\"/\"$OssAccessKeySecret\"/" $FILEPATH
    fi
    if [ -n "$OssEndpoint" ]; then
        sed -i "/OssEndpoint/s/\"\"/\"$OssEndpoint\"/" $FILEPATH
    fi
    if [ -n "$OssBucketName" ]; then
        sed -i "/OssBucketName/s/\"\"/\"$OssBucketName\"/" $FILEPATH
    fi
    if [ -n "$OssPath" ]; then
        sed -i "/OssPath/s/\"\"/\"$OssPath\"/" $FILEPATH
    fi
    if [ -n "$AutoTranscodingDelFile" ]; then
        sed -i "/AutoTranscodingDelFile/s/0/$AutoTranscodingDelFile/" $FILEPATH
    fi
    if [ -n "$ServerName" ]; then
        sed -i "/ServerName/s/DDTVServer/$ServerName/" $FILEPATH
    fi
    if [ -n "$ServerAID" ]; then
        sed -i "/ServerAID/s/8198ae60-094f-48a6-8272-1c2be8959c6a/$ServerAID/" $FILEPATH
    fi
    if [ -n "$ServerGroup" ]; then
        sed -i "/ServerGroup/s/default/$ServerGroup/" $FILEPATH
    fi
    if [ -n "$ApiToken" ]; then
        sed -i "/ApiToken/s/1145141919810A/$ApiToken/" $FILEPATH
    fi
    if [ -n "$WebUserName" ]; then
        sed -i "/WebUserName/s/ami/$WebUserName/" $FILEPATH
    fi
    if [ -n "$WebPassword" ]; then
        sed -i "/WebPassword/s/ddtv/$WebPassword/" $FILEPATH
    fi
    if [ -n "$WebhookUrl" ]; then
        sed -i "/WebhookUrl/s/\"\"/\"$WebhookUrl\"/" $FILEPATH
    fi
    if [ -n "$WebhookEnable" ]; then
        sed -i "/WebhookEnable/s/0/$WebhookEnable/" $FILEPATH
    fi
    if [ -n "$WebSocketPort" ]; then
        sed -i "/WebSocketPort/s/11451/$WebSocketPort/" $FILEPATH
    fi
    if [ -n "$WebSocketEnable" ]; then
        sed -i "/WebSocketEnable/s/0/$WebSocketEnable/" $FILEPATH
    fi
    if [ -n "$WebSocketUserName" ]; then
        sed -i "/WebSocketUserName/s/defaultUserName/$WebSocketUserName/" $FILEPATH
    fi
    if [ -n "$WebSocketPassword" ]; then
        sed -i "/WebSocketPassword/s/defaultPassword/$WebSocketPassword/" $FILEPATH
    fi
    if [ -n "$DefaultFileName" ]; then
        sed -i "/DefaultFileName/s/{date}_{title}_{time}/$DefaultFileName/" $FILEPATH
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
