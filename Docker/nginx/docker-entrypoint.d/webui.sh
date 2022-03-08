#!/bin/bash
#
# 参数更新需修改start.sh README.md docker-compose.yml
[ -e '/start.sh' ] || echo '
    ____  ____  _______    __     _____  ____
   / __ \/ __ \/_  __/ |  / /    |__  / / __ \
  / / / / / / / / /  | | / /      /_ < / / / /
 / /_/ / /_/ / / /   | |/ /     ___/ // /_/ /
/_____/_____/ /_/    |___/     /____(_)____/

     _       ____________     __  ______
    | |     / / ____/ __ )   / / / /  _/
    | | /| / / __/ / __  |  / / / // /
    | |/ |/ / /___/ /_/ /  / /_/ // /
    |__/|__/_____/_____/   \____/___/'

DDTV_Path=/DDTV
Backups_Path=/DDTV_Backups
# 检测 DDTV 目录文件是否齐全
cd "$DDTV_Path" || exit
if [ "$(ls -A "$Backups_Path")" ]; then
    shopt -s globstar nullglob
    for file in "$Backups_Path"/**; do
        [ "${file##"$Backups_Path"/}" = "" ] && continue
        [ ! -e "${file##"$Backups_Path"/}" ] && cp -vur "$file" "${file##"$Backups_Path"/}"
    done
fi

# 第一次启动修改信息
if [ ! -e "/NotIsFirstStart" ]; then

    File_Path=$DDTV_Path/static/static/config.js
    if [ -n "$apiUrl"    ]; then
        sed -i "/apiUrl/s|:.*,|: \"$apiUrl\",|"                      "$File_Path" ; fi
    if [ -n "$mount"    ]; then
        sed -i "/mount/s|'.*'|'$mount'|"                             "$File_Path" ; fi

    File_Path=$DDTV_Path/static/static/barinfo.js
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

    touch /NotIsFirstStart
fi
