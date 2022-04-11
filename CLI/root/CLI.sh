#!/bin/bash
echo '
    ____  ____  _______    __   _____  ____         ________    ____
   / __ \/ __ \/_  __/ |  / /  |__  / / __ \       / ____/ /   /  _/
  / / / / / / / / /  | | / /    /_ < / / / /      / /   / /    / /
 / /_/ / /_/ / / /   | |/ /   ___/ // /_/ /      / /___/ /____/ /
/_____/_____/ /_/    |___/   /____(_)____/       \____/_____/___/
'
set -e; set -u

# 参数更新需修改 README.md docker-compose.yml
# 可用参数有: 
#   --no-update
case "$*" in
    ""|*"--no-update"*)
        ./checkup.sh
        cd /DDTV
        # 更新 DDTV
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
    gosu $PUID:$PGID dotnet DDTV_CLI.dll
elif [[ "$ID" == "alpine" ]]; then
    su-exec $PUID:$PGID dotnet DDTV_CLI.dll
else
    echo "未支持$ID" && exit 1
fi
