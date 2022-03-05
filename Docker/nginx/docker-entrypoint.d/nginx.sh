#!/bin/sh
#
HTMLPATH=/usr/share/nginx/html

FILEPATH=$HTMLPATH/static/config.js
if [ -n "$apiUrl" ]; then
    sed -i "/apiUrl/s|:.*,|: \"$apiUrl\",|" $FILEPATH
fi
if [ -n "$mount" ]; then
    sed -i "/mount/s|'.*'|'$mount'|" $FILEPATH
fi

FILEPATH=$HTMLPATH/static/barinfo.js
if [ -n "$show" ]; then
    sed -i "/    show/s|: .*,|: $show,|" $FILEPATH
fi
if [ -n "$infoshow" ]; then
    sed -i "/info.*show/s|show:.*text|show: $infotext, text|" $FILEPATH
fi
if [ -n "$infotext" ]; then
    sed -i "/info.*text/s|text.*link|text: \"$infotext\", link|" $FILEPATH
fi
if [ -n "$infolink" ]; then
    sed -i "/info.*link/s|link.*}|link: \"$infolink\" }|" $FILEPATH
fi
if [ -n "$ICPshow" ]; then
    sed -i "/ICP.*show/s|show.*text|show: $ICPshow, text|" $FILEPATH
fi
if [ -n "$ICPtext" ]; then
    sed -i "/ICP.*show/s|text.*link|show: \"$ICPtext\", link|" $FILEPATH
fi
if [ -n "$ICPlink" ]; then
    sed -i "/ICP.*link/s|link.*}|link: \"$ICPlink\" }|" $FILEPATH
fi
if [ -n "$GAshow" ]; then
    sed -i "/GA.*show/s|show.*text|show: $GAshow, text|" $FILEPATH
fi
if [ -n "$GAtext" ]; then
    sed -i "/GA.*show/s|text.*link|show: \"$GAtext\", link|" $FILEPATH
fi
if [ -n "$GAlink" ]; then
    sed -i "/GA.*link/s|link.*}|link: \"$GAlink\" }|" $FILEPATH
fi