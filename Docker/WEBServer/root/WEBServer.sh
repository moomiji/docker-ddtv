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
|__/|__/_____/_____/   /____/\___/_/    |___/\___/_/'

set -e; set -u
./checkup.sh
cd /DDTV

echo 
echo "Running as UID ${PUID:=$UID} and GID ${PGID:=$PUID}."
echo 

# 参数更新需修改 README.md docker-compose.yml
# 可用参数有: 
#   --no-arguments
#   --no-update
ARGs=${*:-"--no-arguments"}

# 测试用
if [[ "$ARGs" != "--"* ]]; then
    echo "exec $ARGs"
    eval "$ARGs"
    exit $?
fi

# 更新 DDTV
if [[ "$ARGs" != *"--no-update"* ]]; then
    dotnet DDTV_Update.dll docker
fi

# 运行 DDTV
. /etc/os-release
if [[ "$ID" == "debian" ]]; then
    gosu $PUID:$PGID dotnet DDTV_WEB_Server.dll
elif [[ "$ID" == "alpine" ]]; then
    su-exec $PUID:$PGID dotnet DDTV_WEB_Server.dll
else
    echo "未支持$ID" && exit 1
fi
