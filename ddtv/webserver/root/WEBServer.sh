#!/bin/bash
echo '
          ____  ____  _______    __     _____  ____
         / __ \/ __ \/_  __/ |  / /    |__  / / __ \
        / / / / / / / / /  | | / /      /_ < / / / /
       / /_/ / /_/ / / /   | |/ /     ___/ // /_/ /
      /_____/_____/ /_/    |___/     /____(_)____/
 _       ____________     _____
| |     / / ____/ __ )   / ___/___  ______   _____  _____
| | /| / / __/ / __  |   \__ \/ _ \/ ___/ | / / _ \/ ___/
| |/ |/ / /___/ /_/ /   ___/ /  __/ /   | |/ /  __/ /
|__/|__/_____/_____/   /____/\___/_/    |___/\___/_/
'
set -e; set -u

# 参数更新需修改 README.md docker-compose.yml
# 可用参数有:
#   --no-update 不更新 DDTV
#   --verbose   脚本输出更多信息（若服务器多人使用docker，请谨慎使用该参数，因为会将DDTV中的个人信息\配置输出到docker日志中）
case "$*" in
    ""|*"--verbose"*|*"--no-update"*)
        ./checkup.sh "$@"
        cd /DDTV
        [[ "$*" == *"--no-update"* ]] || dotnet DDTV_Update.dll docker
        ;;
    *)  # 运行测试命令
        echo "eval $*" && eval "$*" && exit $?
        ;;
esac

# 运行 DDTV
# 可用参数有:
#   $PUID
#   $PGID
#   $DownloadPath
#   $TmpPath
. /etc/os-release
echo "Running as UID ${PUID:=$UID} and GID ${PGID:=$PUID}."
mkdir -vp "${DownloadPath:=./Rec/}" "${TmpPath:=./tmp/}"
chown -R "$PUID:$PGID" /DDTV "$DownloadPath" "$TmpPath"

if [[ "$ID" == "debian" ]]; then
    gosu $PUID:$PGID dotnet DDTV_WEB_Server.dll
elif [[ "$ID" == "alpine" ]]; then
    su-exec $PUID:$PGID dotnet DDTV_WEB_Server.dll
else
    echo "未支持$ID" && exit 1
fi
