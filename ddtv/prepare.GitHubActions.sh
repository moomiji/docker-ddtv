#!/bin/bash
set -e; set -u
# $1: $*_REPO in Docker_Release.yml#jobs.Prepare.outputs
# $2: ${{ secrets.GITHUB_TOKEN }}
# $3: DDTV build output path
case $1 in
    ddtv/cli)
        Keyword=CLI
        ;;
esac
KeyFile=Core.dll
shopt -s globstar nullglob
cd ./**/"$1"

header="authorization: Bearer $2"
# 下载DDTV
if [[ -n "${3:-}" ]]; then File_Path=$3; else
curl -sfLOH "$header" "https://api.github.com/repos/CHKZL/DDTV/releases/latest"                             \
     && curl -sfLOH "$header" "$(cat < latest | awk '/download_url/{print $4}' FS='"' | grep -i $Keyword -m 1 )" \
     && File_Path="$(            cat < latest | awk '/name/{print $4}'         FS='"' | grep -i $Keyword -m 1 )" \
     && 7z x -bd "$File_Path"                                                                               \
     && echo "Extract ($File_Path) succeeded"                                                               \
     && File_Path=$(7z l "$File_Path" | awk "/$KeyFile/{print \$6}" | awk '{print $1}' FS="/$KeyFile")      \
     && echo "File path ($File_Path) geted"                                                                 \
     || eval 'echo "Failed to get File path OR extract" && exit 1'
fi

# 转移DDTV
mv -v "$File_Path"            \
          ./root/DDTV
mv -v ../docker-entrypoint.sh \
          ./root
mv -v ../*-*.sh               \
          ./root/docker-entrypoint.d
