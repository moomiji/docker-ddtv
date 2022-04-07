#!/usr/bin/env bash
#

DDTV_short_name="DDTV"
DDTV_full_name="DDTV_WEB_Server"
logfile="DDTV-install.log"

#=默认信息====================#
# dotnet_version=("6.1" "6.0" ...)  必须 主版本号.子版本号 否则匹配的可能不对
# 版本大的在前！！！
dotnet_version=("6.0")  # DDTV latest版本可用的 dotnet version
dotnet_install_dir=     # 为空时自动判断
dotnet_download_url="http://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh"
# https://dot.net/v1/dotnet-install.sh

DDTV_version="latest"   # Ver3.0.*.*
DDTV_install_dir=       # 为空时自动判断
DDTV_download_url="https://download.fastgit.org/CHKZL/DDTV/releases/download" # 结尾不带/   # like "${DDTV_download_url}/${DDTV_version}/${DDTV_full_name}_${DDTV_version:3}.zip"
# https://github.com/CHKZL/DDTV/releases/download 太慢了，有需要直接换             # exp  https://github.com/CHKZL/DDTV/releases/download/Ver3.0.1.6/DDTV_WEB_Server_3.0.1.6.zip

#=默认模式====================#
is_install=true         # 卸载模式          | false true
is_verbose=false        # 调试模式          | false true
is_need_log=false       # 安装完成后不删日志 | false true
is_suitable_dotnet=true # 具有正确的 dotnet | false true
failed=false            # 执行失败
_sudo=                  # 执行sudo命令      | "sudo" root用户:"   " 普通用户无sudo:" "

is_exec_deps_cmd=-1     # 安装/卸载 依赖    | -1 false true
is_exec_dotnet_cmd=-1   # 安装/卸载 dotnet  | -1 false true
is_exec_service_cmd=-1  # 安装/卸载 服务    | -1 false true
is_exec_DDTV_cmd=-1     # 安装/卸载 DDTV    | -1 false true
is_install_ffmpeg=-1    # 安装ffmpeg        | -1 false true

exec_mode="package"     # dotnet 安装/卸载模式 | 默认为package，并在开始时检查权限 | package root user
supported_dotnet_package=false # 支持通过包管理器命令安装/卸载 dotnet | false apt

#=环境变量====================#
uname=$(whoami)
script_name=$(basename "$0")
temporary_file_template="${TMPDIR:-/tmp}/${DDTV_short_name}.XXXXXX"

architecture="<auto>"   # 架构
download=               # 保持原文件名的下载命令 wget curl
download_to=            # 下载至 /path/file 的下载命令

#=输出函数====================#
# Stop script on NZEC
# set -e  # 脚本使用exit退出，而不是return 1 (return的值用于if while)
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u
# By default cmd1 | cmd2 returns exit code of cmd2 regardless of cmd1 success
# This is causing it to fail
set -o pipefail

# Use in the the functions: eval $invocation
invocation='say_verbose "${normal:-}Calling: ${yellow:-}${FUNCNAME[0]} ${green:-}$*${normal:-}"'

# standard output may be used as a return value in the functions
# we need a way to write text on the screen in the functions so that
# it won't interfere with the return value.
# Exposing stream 3 as a pipe to standard output of the script itself
exec 3>&1

# Setup some colors to use. These need to work in fairly limited shells, like the Ubuntu Docker container where there are only 8 colors.
# See if stdout is a terminal
if [ -t 1 ] && command -v tput > /dev/null; then
    # see if it supports colors
    ncolors=$(tput colors || echo 0)
    if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
      # bold="$(tput bold       || echo)"
        normal="$(tput sgr0     || echo)"
      # black="$(tput setaf 0   || echo)"
        red="$(tput setaf 1     || echo)"
      # green="$(tput setaf 2   || echo)"
        yellow="$(tput setaf 3  || echo)"
      # blue="$(tput setaf 4    || echo)"
      # magenta="$(tput setaf 5 || echo)"
        cyan="$(tput setaf 6    || echo)"
      # white="$(tput setaf 7   || echo)"
    fi
fi

say_warning() {
    printf "%b\n" "${yellow:-}${DDTV_short_name}_install:[Warning] $1${normal:-}" | tee -a ${logfile} >&3
}

say_err() {
    printf "%b\n" "${red:-}${DDTV_short_name}_install:[Error] $1${normal:-}"      | tee -a ${logfile} >&2
}

say() {
    printf "%b\n" "${cyan:-}${DDTV_short_name}-install: [info]${normal:-} $1"     | tee -a ${logfile} >&3
}

say_verbose() {
    if [[ $is_verbose == true ]]; then
        printf "%b\n" "${cyan:-}${DDTV_short_name}-install:[debug]${normal:-} $1" | tee -a ${logfile} >&3
    else
        printf "%b\n" "${cyan:-}${DDTV_short_name}-install:[debug]${normal:-} $1"       >> ${logfile}
    fi
}

#=带信息的输出====================#

say_err_script_not_updated() {
    local unit
    case ${FUNCNAME[1]} in
        *deps)    unit="依赖"   ; [[ $is_install_ffmpeg == true ]] && unit="依赖 和 ffmpeg" ;;
        *dotnet)  unit="dotnet" ;;
        *DDTV)    unit="DDTV"   ;;
        *service) unit="服务"   ;;
    esac
    say_err "脚本已经好久没更新了，请自行${anvl} $unit ，欢迎反馈。"
}

say_err_script_not_supported() {
    local unit
    case ${FUNCNAME[1]} in
        *deps)    unit="依赖"   ;;
        *dotnet)  unit="dotnet" ;;
        *DDTV)    unit="DDTV"   ;;
        *service) unit="服务"   ;;
    esac
    say_err "脚本不支持在 $ID $VERSION_ID 下的 $unit ${anvl}，请自行${anvl} $unit 。"
}

say_err_deps_libgdiplus() {
    say_err "libgdiplus (版本 6.0.1 或更高版本) 微软包储存库已不支持 $ID $VERSION_ID ，请自行${anvl:+"编译"}${anvl}。"
}

say_err_dotnet_not_supported_the_machine() {
    say_err "微软文档未支持 $ID $VERSION_ID 下的 dotnet ${anvl}，请自行通过其他方式${anvl}。"
}

say_warning_dotnet_not_supported_package_management() {
    say_warning "在微软包存储库中 dotnet 未支持 $ID $VERSION_ID 版本。"
}

say_fuck_done() {
    say_verbose "${red:-}草，不应该执行到这的。${normal:-}"
}

#=用于安装卸载命令====================#

machine_has() {
    command -v "$1" > /dev/null 2>&1
    return $?
}

has_sudo() {
    eval "$invocation"

    if [[ $uname == "root" ]]; then
        _sudo="   "
        return 0
    elif machine_has "sudo" && sudo echo ""; then
        _sudo=" sudo "
        return 0
    fi
    _sudo=" "
    return 1
}

need_sudo_but_not_has_sudo() {
    local exec_func=${FUNCNAME[1]}
    case $exec_func in
        *"service"|*"deps")
            if [[ "$_sudo" == " " ]]; then
                say_err "${exec_func/*_/${anvl} } 需要 sudo 权限。"
                return 0
            fi
            ;;
        *)
            if [[ $exec_mode != "user" ]] && [[ "$_sudo" == " " ]]; then
                say_err "${exec_func/*_/${anvl} } 需要 sudo 权限。"
                return 0
            fi
            ;;
    esac
    return 1
}

check_min_reqs() {
    eval "$invocation"

    local has_minimum=true

    if machine_has "curl"; then
        download="curl${PROXY:+" -x $PROXY"} --retry 5 --retry-delay 2 --connect-timeout 15 -LO"
        download_to="curl${PROXY:+" -x $PROXY"} --retry 5 --retry-delay 2 --connect-timeout 15 -Lo"
    elif machine_has "wget"; then
        download="wget${PROXY:+"-e \"http_proxy=$PROXY\""} --tries 5 --waitretry 2 --connect-timeout 15"
        download_to="wget${PROXY:+" -e \"http_proxy=$PROXY\""} --tries 5 --waitretry 2 --connect-timeout 15 -O"
    else
        has_minimum=false
        say_err "安装${DDTV_full_name}需要 curl(推荐) 或 wget !"
    fi

    if ! machine_has "unzip"; then
        has_minimum=false
        say_err "安装${DDTV_full_name}需要 unzip !"
    fi

    if [[ $has_minimum == false ]]; then
        [[ "$is_need_log" == false ]] && rm -f $logfile && exit 0
    fi

    return 0
}

dotnet_has_been_installed(){
    eval "$invocation"
    local dotnet_info

    if [ -e "$dotnet_install_dir/dotnet" ]; then
        dotnet_info="$($dotnet_install_dir/dotnet --info)"
    elif machine_has "dotnet"; then
        dotnet_info="$(dotnet --info)"
        dotnet_install_dir=$(which dotnet)
    else
        is_suitable_dotnet=false
        return 1
    fi

    for ver in "${dotnet_version[@]}"; do
        if [[ $dotnet_info == *"AspNetCore.App $ver"*"NETCore.App $ver"* ]]; then
            say_verbose "已安装 AspNetCore $ver 和 NETCore $ver 。" && return 0 
        else
            say_verbose "未安装 AspNetCore $ver 或 NETCore $ver 。"
        fi
        if [[ $dotnet_info == *".NET SDKs installed:"*$ver*".NET runtimes installed:"* ]]; then
            say_verbose "已安装 .NET SDKs $ver 。"                  && return 0 
        else
            say_verbose "未安装 .NET SDKs $ver 。"
        fi
    done
    is_suitable_dotnet=false
    return 1
}

DDTV_has_been_installed() {
    eval "$invocation"

    if [ -e "$DDTV_install_dir" ] &&
       [ -e "$DDTV_install_dir/$DDTV_full_name.dll" ]; then

        say " $DDTV_full_name 已安装。"
        is_exec_DDTV_cmd=-1
        while [[ $is_exec_DDTV_cmd == -1 ]]; do
            read -r -e -t 10 -p "${yellow:-}是否覆盖安装 $DDTV_full_name ，这不会导致配置文件被覆盖，但有可能导致其他问题 (y/n): ${normal:-}" yn || if true ; then printf "%b\n" "${yellow:-}已超时，将不会重装 DDTV 。${normal:-}" >&3 ; yn="n" ; fi
            is_exec_DDTV_cmd="$(yn_to_tf "$yn")"
        done
    fi
    [[ $is_exec_DDTV_cmd == true ]] && return 1 || return 0
}

get_machine_architecture() {
    eval "$invocation"

    if machine_has "uname"; then
        CPUName=$(uname -m)
        case $CPUName in
        armv7l)
            echo "arm"
            return 0
            ;;
        armv*l)
            say_err "dotnet 不支持 $CPUName，换个录播姬吧TAT"
            [[ "$is_need_log" == false ]] && rm -f $logfile && exit 0
            ;;
        aarch64|arm64)
            echo "arm64"
            return 0
            ;;
        esac
    fi

    echo "x64" # 默认输出
    return 0
}

check_package() {
    eval "$invocation"

    say_verbose "确认os-release文件。"
    if [ -e "/etc/os-release" ]; then
        . /etc/os-release
    else
        architecture=$(get_machine_architecture)
        say "不存在 /etc/os-release 文件。"
        supported_dotnet_package=false
        return 1
    fi

    say_verbose "确认机器架构。"
    architecture=$(get_machine_architecture)
    if [[ $architecture != "x64" ]]; then
        [[ $is_install == true ]] && say "仅在 x64 体系结构上支持包管理器${anvl} dotnet 。"
        supported_dotnet_package=false
        return 1
    fi

    say_verbose "确认包管理器命令。"
    if machine_has "apt-get"; then
        supported_dotnet_package="apt"
    else
        [[ $is_install == true ]] && say "该系统未有 dotnet ${dotnet_version[0]} 支持的包管理器。"
        supported_dotnet_package=false
        return 1
    fi

    say_verbose "确认系统版本。"
    case $ID in
        debian)
            case $VERSION_ID in
                12|13)
                    say_err_script_not_updated
                    supported_dotnet_package=false
                    return 1
                    ;;
                11|10|9)
                    return 0
                    ;;
                *)
                    say_warning_dotnet_not_supported_package_management
                    supported_dotnet_package=false
                    return 1
                    ;;
            esac
            ;;
        ubuntu)
            case $VERSION_ID in
                22.*|23.*)
                    say_err_script_not_updated
                    supported_dotnet_package=false
                    return 1
                    ;;
                21.*|20.04|18.04|16.04)
                    return 0
                    ;;
                *)
                    say_warning_dotnet_not_supported_package_management
                    supported_dotnet_package=false
                    return 1
                    ;;
            esac
            ;;
        *)
            say_warning_dotnet_not_supported_package_management
            supported_dotnet_package=false
            return 1
            ;;
    esac
    say_fuck_done
}

get_dotnet_package_management_command() {
    eval "$invocation"

    case $ID in
        debian|ubuntu)
            case $is_install in
                true)
                    case $VERSION_ID in
                        21.10)
                            echo -n " && $download https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb"
                            echo -n " && ${_sudo} dpkg -i packages-microsoft-prod.deb"
                            echo -n " && rm -f packages-microsoft-prod.deb"
                            ;;
                        11|10|21.04|20.04|18.04|16.04)
                            echo -n " && $download https://packages.microsoft.com/config/${ID}/${VERSION_ID}/packages-microsoft-prod.deb"
                            echo -n " && ${_sudo} dpkg -i packages-microsoft-prod.deb"
                            echo -n " && rm -f packages-microsoft-prod.deb"
                            ;;
                        9)
                            echo -n " &&${_sudo} $download_to - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg"
                            echo -n " &&${_sudo} mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/"
                            echo -n " &&${_sudo} $download https://packages.microsoft.com/config/debian/9/prod.list"
                            echo -n " &&${_sudo} mv prod.list /etc/apt/sources.list.d/microsoft-prod.list"
                            ;;
                        *)
                            say_fuck_done
                            return 1
                            ;;
                    esac
                    echo -n " && ${_sudo} apt-get update"
                    echo -n " && ${_sudo} apt-get install -y apt-transport-https"
                    echo -n " && ${_sudo} apt-get update"
                    echo -n " && ${_sudo} apt-get install -y aspnetcore-runtime-${dotnet_version[0]}"
                    return 0
                    ;;
                false)
                    echo -n " && ${_sudo} apt-get remove --purge -y aspnetcore-runtime-${dotnet_version[0]} dotnet-runtime*-${dotnet_version[0]}"
                    case $VERSION_ID in
                        11|10|21.*|20.04|18.04|16.04)
                            echo -n " ; ${_sudo} dpkg -r packages-microsoft-prod"
                            ;;
                        9)
                            echo -n " ; ${_sudo} rm -f /etc/apt/trusted.gpg.d/microsoft.asc.gpg"
                            echo -n " ; ${_sudo} rm -f /etc/apt/sources.list.d/microsoft-prod.list"
                            ;;
                        *)
                            say_fuck_done
                            return 1
                            ;;
                    esac
                    return 0
                    ;;
            esac
            ;;
        # alpine and others
        *)
            say_fuck_done
            return 1
            ;;
    esac
}

# tool="$1" 包管理工具命令
get_centos_rhel_fedora_deps_command() {
    eval "$invocation"

    local tool="$1" # 包管理工具命令
    local openssl_ver
    openssl_ver=$(${_sudo} ${tool} info -q openssl-libs | awk '/Version/{print $2;exit}' FS=': ')
    case $is_install in
        true)  echo -n " && ${_sudo} $tool install -q -y""" ;;
        false) echo -n " && ${_sudo} $tool remove -q" ;;
    esac

    echo -n " krb5-libs libicu openssl-libs zlib libgdiplus-devel"
    if [[ "1.1" == $(printf '%s'"$openssl_ver\n1.1" | sort -V | head -n1) ]];then
        echo -n " compat-openssl10"
    fi

    [[ $is_install_ffmpeg == true ]] && \
    if ! ${_sudo}${tool} info -q ffmpeg; then
        is_install_ffmpeg=false
        say_err "当前包存储库无ffmpeg，请自行安装。"
        failed+=" ffmpeg"
    fi
}

#=输出安装卸载命令====================#
# funcname=(un)install_{utilname}
# 方便 *install_{utilname} 直接判断

install_deps(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    case $ID in
        alpine)
            echo -n " && ${_sudo} apk -q update"
            echo -n " && ${_sudo} apk add -q --no-cache libgdiplus --repository https://dl-3.alpinelinux.org/alpine/edge/testing/"
            echo -n " && ${_sudo} apk add -q --no-cache"

            echo -n " icu-libs krb5-libs libgcc libintl libstdc++ zlib"
            # local alpine_ver
            # alpine_ver=($(echo $VERSION_ID | awk '{print $1,$2;exit}' FS='.'))
            # if [[ ${alpine_ver[0]} -ge "3" && ${alpine_ver[1]} -ge "9" ]];then 如果sort -V不可用
            # sort -V | head -n1 —— 取小的版本
            if [[ "3.9" == $(printf '%s' "$VERSION_ID\n3.9" | sort -V | head -n1) ]];then
                echo -n " libssl1.1"
            else
                echo -n " libssl1.0"
            fi
            ;;

        centos|rhel)
            case $VERSION_ID in
                9|9.*)
                    # CentOS Stream 9? ID好像不变
                    say_err_script_not_updated
                    return 1
                    ;;
                7|8|7.*|8.*)
                    echo -n " &&${_sudo}rpmkeys --import \"http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF\""
                    echo -n " &&${_sudo}su -c '$download_to - https://download.mono-project.com/repo/centos${VERSION_ID:0:1}-stable.repo | tee /etc/yum.repos.d/mono-centos${VERSION_ID:0:1}-stable.repo'"
                    if [[ $VERSION_ID == 8* ]]; then
                        echo -n "$(get_centos_rhel_fedora_deps_command "dnf")"
                    else
                        echo -n "$(get_centos_rhel_fedora_deps_command "yum")"
                    fi
                    ;;
                *)
                    say_err_dotnet_not_supported_the_machine
                    return 1
                    ;;
            esac
            ;;

        fedora)
            case $VERSION_ID in
                4*)
                    # CentOS Stream 9? VERSION_ID好像不变
                    say_err_script_not_updated
                    return 1
                    ;;
                29|3*)
                    echo -n " &&${_sudo}rpm --import \"https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF\""
                    echo -n " &&${_sudo}su -c '$download_to - https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo'"
                    echo -n " &&${_sudo}dnf update"
                    echo "$(get_centos_rhel_fedora_deps_command "dnf")"
                    ;;
                28)
                    echo -n " &&${_sudo}rpm --import \"https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF\""
                    echo -n " &&${_sudo}su -c '$download_to - https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'"
                    echo -n " &&${_sudo}dnf update"
                    echo -n "$(get_centos_rhel_fedora_deps_command "dnf")"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        debian)
            if [[ $VERSION_ID == 10 || $VERSION_ID == 9 ]]; then
                echo -n " &&${_sudo}apt install -q=2 -y apt-transport-https dirmngr gnupg ca-certificates"
                echo -n " &&${_sudo}apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
                echo -n " && echo \"deb https://download.mono-project.com/repo/debian stable-${VERSION_CODENAME} main\" |${_sudo}tee /etc/apt/sources.list.d/mono-official-stable.list"
            fi
            echo -n " &&${_sudo}apt update"
            echo -n " &&${_sudo}apt install -q=2 -y"

            echo -n " libgdiplus libc6 libgssapi-krb5-2 libssl1.1 libstdc++6 zlib1g"
            case $VERSION_ID in
                12|13)
                    say_err_script_not_updated
                    return 1
                    ;;
                11) echo -n " libicu67 libgcc-s1"
                    ;;
                10) echo -n " libicu63"
                    ;;
                9)  echo -n " libicu57"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        ubuntu)
            if [[ $VERSION_ID == "18.04" ]]; then
                echo -n " &&${_sudo}apt install -q=2 -y gnupg ca-certificates"
                echo -n " &&${_sudo}apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
                echo -n " && echo \"deb https://download.mono-project.com/repo/ubuntu stable-${VERSION_CODENAME} main\" |${_sudo}tee /etc/apt/sources.list.d/mono-official-stable.list"
            elif [[ $VERSION_ID == "16.04" ]]; then
                echo -n " &&${_sudo}apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
                echo -n " &&${_sudo}apt install -q=2 -y apt-transport-https ca-certificates"
                echo -n " && echo \"deb https://download.mono-project.com/repo/ubuntu stable-${VERSION_CODENAME} main\" |${_sudo}tee /etc/apt/sources.list.d/mono-official-stable.list"
            fi
            echo -n " &&${_sudo}apt update -q=2"
            echo -n " &&${_sudo}apt install -q=2 -y"

            echo -n " libgdiplus libc6 libgcc1 libgssapi-krb5-2 libstdc++6 zlib1g"
            case $VERSION_ID in
                22.*|23.*)
                    say_err_script_not_updated
                    return 1
                    ;;
                21.*)  echo -n " libicu67 libssl1.1"
                    ;;
                20.04) echo -n " libicu66 libssl1.1"
                    ;;
                18.04) echo -n " libicu60 libssl1.1"
                    ;;
                16.04) echo -n " libicu55 libssl1.0.0"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        *)
            say_err_script_not_supported
            return 1
            ;;
    esac

    [[ $is_install_ffmpeg == true ]] && echo -n " ffmpeg"
    return 0
}

uninstall_deps(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    case $ID in
        alpine)
            echo -n " &&${_sudo}apk del -q"

            echo -n " libgdiplus icu-libs krb5-libs libgcc libintl libstdc++ zlib"
            if [[ "3.9" == $(printf '%s' "$VERSION_ID\n3.9" | sort -V | head -n1) ]];then
                echo -n " libssl1.1"
            else
                echo -n " libssl1.0"
            fi
            ;;

        centos|rhel)
            case $VERSION_ID in
                9|9.*)
                    # CentOS Stream 9? ID好像不变
                    say_err_script_not_updated
                    return 1
                    ;;
                7|8|7.*|8.*)
                    if [[ $VERSION_ID == 8* ]]; then
                        echo -n "$(get_centos_rhel_fedora_deps_command "dnf")"
                    else
                        echo -n "$(get_centos_rhel_fedora_deps_command "yum")"
                    fi
                    echo -n " && ${_sudo} rm -f /etc/yum.repos.d/mono-centos*-stable.repo "
                    ;;
                *)
                    say_err_dotnet_not_supported_the_machine
                    return 1
                    ;;
            esac
            ;;

        fedora)
            case $VERSION_ID in
                4*)
                    # CentOS Stream 9? VERSION_ID好像不变
                    say_err_script_not_updated
                    return 1
                    ;;
                28|29|3*)
                    echo -n "$(get_centos_rhel_fedora_deps_command "dnf")"
                    echo -n " && ${_sudo} rm -f /etc/yum.repos.d/mono-centos*-stable.repo"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        debian)
            echo -n " && ${_sudo} rm -f /etc/apt/sources.list.d/mono-official-stable.list"
            echo -n " &&${_sudo}apt remove --purge -q=2"

            echo -n " libgdiplus libc6 libgssapi-krb5-2 libssl1.1 libstdc++6 zlib1g"
            case $VERSION_ID in
                12|13)
                    say_err_script_not_updated
                    return 1
                    ;;
                11) echo -n " libicu67 libgcc-s1"
                    ;;
                10) echo -n " libicu63"
                    ;;
                9)  echo -n " libicu57"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        ubuntu)
            echo -n " && ${_sudo} rm -f /etc/apt/sources.list.d/mono-official-stable.list"
            echo -n " && ${_sudo} apt remove --purge -q=2"

            echo -n " libgdiplus libc6 libgcc1 libgssapi-krb5-2 libstdc++6 zlib1g"
            case $VERSION_ID in
                22.*|23.*)
                    say_err_script_not_updated
                    return 1
                    ;;
                21.*)  echo -n " libicu67 libssl1.1"
                    ;;
                20.04) echo -n " libicu66 libssl1.1"
                    ;;
                18.04) echo -n " libicu60 libssl1.1"
                    ;;
                16.04) echo -n " libicu55 libssl1.0.0"
                    ;;
                *)
                    say_err_deps_libgdiplus
                    return 1
                    ;;
            esac
            ;;

        *)
            say_err_script_not_supported
            return 1
            ;;
    esac

    return 0
}

install_dotnet(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    case $exec_mode in
        package)
            echo -n "$(get_dotnet_package_management_command)" || return 1
            ;;
        root)
            echo -n " && $download_to dotnet-install.sh $dotnet_download_url"
            echo -n " && chmod 777 dotnet-install.sh"
            echo -n " &&${_sudo}./dotnet-install.sh -c ${dotnet_version[0]} -i $dotnet_install_dir --runtime aspnetcore"
            [[ $is_verbose == true ]] && echo -n " --verbose"
            echo -n " && rm -f dotnet-install.sh"
            echo -n " &&${_sudo}ln -sf $dotnet_install_dir/dotnet /usr/bin/dotnet"
            ;;
        user)
            echo -n " && bash <($download_to - $dotnet_download_url) -c ${dotnet_version[0]} -i $dotnet_install_dir --runtime aspnetcore"
            [[ $is_verbose == true ]] && echo -n " --verbose"
            ;;
    esac
    return 0
}

uninstall_dotnet(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    case $exec_mode in
        package)
            echo -n "$(get_dotnet_package_management_command)" || return 1
            ;;
        root)
            echo -n " && ${_sudo} rm -rf $dotnet_install_dir /usr/bin/dotnet"
            ;;
        user)
            echo -n " && rm -rf $dotnet_install_dir"
            ;;
    esac
    return 0
}

install_DDTV(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1
    DDTV_has_been_installed && echo -n " && say \"将不会重装 $DDTV_full_name 。\"" && return 0

    local download_url
    local file_path
    local zip_path
    local unzip_temp_path
    local DDTV_latest_version

    zip_path="$(mktemp "$temporary_file_template")"           && say_verbose "Zip 临时路径: $zip_path"
    unzip_temp_path="$(mktemp -d "$temporary_file_template")" && say_verbose "临时解压路径: $unzip_temp_path"
    $download_to $zip_path https://api.github.com/repos/CHKZL/DDTV/releases/latest || if true ; then say_err "下载失败，请检查网络连接。" ; rm -rf $zip_path $unzip_temp_path ; return 1 ; fi
    DDTV_latest_version="$(awk '/tag_name/{print $4;exit}' FS='"' $zip_path)"

    if [[ $DDTV_version == "latest" ]]; then
        DDTV_version=$DDTV_latest_version
        # 你永远不知道米姐的命名会多些什么或些少什么，但有点是不变的：api中的 "name": "DDTV_W
        download_url="$(awk '/"name": "DDTV_W/{print $4;exit}' FS='"' $zip_path)"
                  # ="DDTV_WEB_Server_3.0.1.6.zip"
        download_url="${DDTV_download_url}/${DDTV_version}/${download_url}"
    else
        # 指定版本的大部分都能对
        download_url="${DDTV_download_url}/${DDTV_version}/${DDTV_full_name}_${DDTV_version:3}.zip"
    fi
    say_verbose "下载命令: $download_to $zip_path $download_url"
    $download_to $zip_path $download_url || if true ; then say_err "$DDTV_full_name ${DDTV_version} 下载失败，请检查网络连接。" ; rm -rf $zip_path $unzip_temp_path ; return 1 ; fi

    # 你永远不知道米姐的命名会套几层文件夹
    file_path="$DDTV_full_name.dll"
    file_path=$(unzip -l "$zip_path" | awk "/$file_path/{print \$4;exit}" FS=' ' | awk '{print $1;exit}' FS="$file_path")
           # ="(.zip/)*/*/"
    if [[ "$file_path" == "" ]]; then say_err "$zip_path 解压测试失败，请重试。"; rm -rf $unzip_temp_path; return 1; fi
    # 安装 DDTV
    echo -n " && unzip -q -d $unzip_temp_path $zip_path"
    echo -n " && rm -f $zip_path"

    echo -n " && cd $unzip_temp_path/$file_path"
    echo -n " && ${_sudo} mkdir -p $DDTV_install_dir"
    echo -n " && ${_sudo} mv -f ./* $DDTV_install_dir"
    echo -n " && cd $PWD"
    echo -n " && rm -rf $unzip_temp_path"

    echo -n " && ${_sudo} chown -R $uname:$uname $DDTV_install_dir"
    echo -n " && ${_sudo} chmod -R 755 $DDTV_install_dir"
    return 0
}

uninstall_DDTV(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    [[ "$_sudo" != " " ]] && echo -n " && ${_sudo} systemctl stop $DDTV_short_name"
    echo -n " ; ${_sudo} rm -rf $DDTV_install_dir "
    return 0
}

install_service(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    if machine_has "dotnet" && machine_has "systemctl" && [ -e "$DDTV_install_dir/$DDTV_full_name.dll" ]; then
        echo -n " && ${_sudo} /bin/bash -c 'echo \"[Unit]
Description=DDTV WEB Server
Documentation=https://ddtv.pro/
After=network-online.target
Wants=network-online.target

[Service]
User=$uname
WorkingDirectory=$HOME/.DDTV
ExecStart=$dotnet_install_dir/dotnet $DDTV_full_name.dll
Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target
Alias=ddtv.service\" > /lib/systemd/system/$DDTV_short_name.service'"
        echo -n " && ${_sudo} systemctl daemon-reload"
        return 0
    else
        say_err "机器未安装 $DDTV_full_name 或 合适版本的dotnet 或 systemctl，请安装后重试！"
        return 1
    fi
}

uninstall_service(){
    eval "$invocation"
    need_sudo_but_not_has_sudo && return 1

    echo -n " && ( ${_sudo} systemctl stop $DDTV_short_name"
    echo -n " ;    ${_sudo} systemctl disable $DDTV_short_name"
    echo -n " ;    ${_sudo} rm -f /lib/systemd/system/$DDTV_short_name.service"
    echo -n " ) && ${_sudo} systemctl daemon-reload"
}

#=检测脚本参数====================#
while [ $# -ne 0 ]; do
    name="$1"
    shift

    case "$name" in
        -i|--install|-[Ii]nstall)
            is_install=true

            is_exec_deps_cmd=-1; is_exec_dotnet_cmd=-1; is_exec_service_cmd=-1; is_exec_DDTV_cmd=-1
            while [ $# -ne 0 ]; do
                case $1 in
                    [Dd]ep|[Dd]eps|[Dd]ependencies)
                        is_exec_deps_cmd=true
                        ;;
                    [Dd]otnet)
                        is_exec_dotnet_cmd=true
                        ;;
                    DDTV|[Dd]dtv)
                        is_exec_DDTV_cmd=true
                        ;;
                    [Ss]|[Ss]ervice)
                        is_exec_service_cmd=true
                        ;;
                    [Aa]|[Aa]ll)
                        is_exec_deps_cmd=true; is_exec_dotnet_cmd=true; is_exec_service_cmd=true; is_exec_DDTV_cmd=true
                        ;;
                    *)
                        break
                        ;;
                esac
                shift
            done
            ;;
        -u|--uninstall|-[Uu]ninstall|-r|--remove|-[Rr]emove)
            is_install=false

            is_exec_deps_cmd=-1; is_exec_dotnet_cmd=-1; is_exec_service_cmd=-1; is_exec_DDTV_cmd=-1
            while [ $# -ne 0 ]; do
                case $1 in
                    [Dd]ep|[Dd]eps|[Dd]ependencies)
                        is_exec_deps_cmd=true
                        ;;
                    [Dd]otnet)
                        is_exec_dotnet_cmd=true
                        ;;
                    DDTV|[Dd]dtv)
                        is_exec_DDTV_cmd=true
                        ;;
                    [Ss]|[Ss]ervice)
                        is_exec_service_cmd=true
                        ;;
                    [Aa]|[Aa]ll)
                        is_exec_deps_cmd=true; is_exec_dotnet_cmd=true; is_exec_service_cmd=true; is_exec_DDTV_cmd=true
                        ;;
                    *)
                        break
                        ;;
                esac
                shift
            done
            ;;
        -v|--version|-[Vv]ersion)
            while [ $# -ne 0 ]; do
                case $1 in
                    Ver*.*.*.*) DDTV_version=$1
                    ;;
                    *.*) dotnet_version=("$1")
                    ;;
                    *) break
                    ;;
                esac
                shift
            done
            ;;
        -m|--mode|-[Mm]ode)
            case $1 in
                [Pp]|[Pp]ackage) exec_mode="package"
                ;;
                [Rr]|[Rr]oot) exec_mode="root"
                ;;
                [Uu]|[Uu]ser|[Uu]sr) exec_mode="user"
                ;;
                *) continue
                ;;
            esac
            shift
            ;;
        -p|--proxy|-[Pp]roxy)
            if machine_has "curl"; then
                PROXY="$1"
            else
                say_err "使用 [-p|--proxy|-[Pp]roxy] 参数需要 curl !"
                [[ "$is_need_log" == false ]] && rm -f $logfile && exit 0
            fi
            shift
            ;;
        -d|--directory|-[Dd]irectory)
            while [ $# -ne 0 ] && [[ "$1" == *"/"* ]]; do
                dir="${1%/}"
                if echo "${dir##*/}" | grep -qi "DDTV"; then
                    DDTV_install_dir="$dir"
                elif echo "${dir##*/}" | grep -qi "dotnet"; then
                    dotnet_install_dir="$dir"
                else
                   [[ $DDTV_install_dir == "<auto>" ]] && DDTV_install_dir="$dir/DDTV"
                   [[ $dotnet_install_dir == "<auto>" ]] && dotnet_install_dir="$dir/dotnet"
                fi
                shift
            done
            ;;
        --verbose|-[Vv]erbose|--debug|-[Dd]ebug)
            is_verbose=true
            ;;
        --need-log)
            is_need_log=true
            ;;
        -h|--help|-[Hh]elp|-?|--?)
            echo ""
            echo -e "DDTV Installer，请确保有bash，并使用 ./$script_name ，而不是 sudo ./$script_name 执行，以避免可能存在的权限问题。"
            echo -e "用法: $script_name\t[-i|--install <NAME1> <NAME2> ...]"
            echo -e "                  \t[-u|--uninstall <NAME1> <NAME2> ...] [-r|--remove <NAME1> <NAME2> ...]"
            echo -e "                  \t[-v|--version <DDTV_VERSION> <DOTNET_VERSION>]"
            echo -e "                  \t[-m|--mode <MODE>]"
            echo -e "                  \t[-p|--proxy <PROXY>]"
            echo -e "                  \t[-d|--directory <DIR>]"
            echo -e "      $script_name\t -h|-?|--help"
            echo ""
            echo "$script_name 是一个用于安装、卸载 $DDTV_full_name 及其相关组件的简单脚本。"
            echo ""
            echo "选项:"
            echo "  -i,--install <NAME1> <NAME2> ...   | 只安装名为 <NAME> 的组件，该选项未使用时，默认安装 DDTV 与依赖，其他询问。"
            echo "      -<NAME> 支持选择多个可用值:"
            echo "          - deps    dependencies       安装 dotnet ${dotnet_version[0]} 与 DDTV $DDTV_version 依赖，仅在模式 package 下可用。"
            echo "          - dotnet                     安装 dotnet 。"
            echo "          - DDTV                       安装 $DDTV_full_name 。"
            echo "          - service s                  添加 $DDTV_full_name 到服务，需要当前终端能执行 dotnet systemctl 命令。"
            echo "          - all     a                  安装 所有组件。"
            echo ""
            echo "  -u,--uninstall <NAME1> <NAME2> ... | 只卸载名为 <NAME> 的组件，该选项未使用时，卸载前会进行询问。"
            echo "  -r,--remove    <NAME1> <NAME2> ... |"
            echo "      -<NAME> 支持选择多个可用值:"
            echo "          - deps    dependencies       卸载 dotnet ${dotnet_version[0]} 与 DDTV $DDTV_version 依赖，仅在模式 package 下可用"
            echo "          - dotnet                     卸载 dotnet 。"
            echo "          - DDTV                       卸载 $DDTV_full_name 。"
            echo "          - service s                  删除 $DDTV_full_name 从服务中。"
            echo "          - all     a                  卸载 所有组件。"
            echo ""
            echo "  -v,--version <VERSION1> <VERSION2> | 选择 $DDTV_full_name 与 dotnet 的版本。"
            echo "      -<VERSION> 可选至多 2 个可用值:"
            echo "          - <DDTV_VERSION>    $DDTV_full_name 版本，以 Ver 开头，形如 \" Ver*.*.*.* \"，如 Ver3.0.1.6 。"
            echo "          - <DOTNET_VERSION>           dotnet 版本，以 数字 开头，形如 \" *.* \"，如 6.0 。"
            echo ""
            echo "  -m,--mode <MODE>                   | 安装(卸载) dotnet 的模式，该选项未使用时，安装(卸载)前会自动选择。"
            echo "      -<MODE> 只能选择 1 个可用值:"
            echo "          - package p      (root/sudo) 通过包管理器安装 dotnet ，需要 管理员 权限及脚本支持的包管理器。"
            echo "          - root    r      (root/sudo) 安装 dotnet 的二进制文件，需要 管理员 权限。"
            echo "          - user    u                  通过微软脚本安装 dotnet ，无需 管理员 权限。"
            echo "      注意: user 模式不支持安装依赖。"
            echo "      安装路径: - package root         模式下为 $HOME/.DDTV /usr/share/dotnet"
            echo "                - user                 模式下为 $HOME/.DDTV $HOME/.dotnet"
            echo ""
            echo "  -d,--directory <DIR>              | 指定 DDTV 或 dotnet 的安装路径。"
            echo "      -<DIR> 可选至多 2 个可用值:"
            echo "          - <  DDTV  安装路径(以  DDTV  结尾 忽略大小写) >    e.g. /path1/DDTV"
            echo "          - < dotnet 安装路径(以 dotnet 结尾 忽略大小写) >    e.g. /path2/dotnet"
            echo "          - < 安装到同一路径下 >    e.g. /path3    ( DDTV: /path3/DDTV  dotnet: /path3/dotnet )"
            echo "          注意: "
            echo "                若不带关键字指定 DDTV dotnet 路径，请直接修改脚本。"
            echo "                指定 dotnet 安装路径仅在模式 root user 下可用。"
            echo "             ★ 请根据目标路径的权限选择合适的模式。"
            echo "                若只指定 DDTV 的安装路径，dotnet将安装到当前模式下的默认路径；只指定 dotnet 同理。"
            echo ""
            echo "  -p,--proxy <PROXY>                | 下载 DDTV 时可以指定代理以加速下载，必须安装有curl。"
            echo "      -<PROXY> 只能有 1 个可用值:"
            echo "          e.g. -p http://127.0.0.1:11451 or -p socks5://127.0.0.1:11451"
            echo ""
            echo "  -verbose,--verbose,-debug,--debug | 打开调试输出。"
            echo "" 
            echo "  -?,--?,-h,--help,-Help            | 显示这条帮助信息。"
            echo ""
            exit 0
            ;;
        *)
            say_err "未知参数 \"$name\" ，请查看 \"./$script_name -h\""
            exit 1
            ;;
    esac
done

#=询问安装卸载信息====================#
# yes/no → true/false
yn_to_tf(){
    case "${1:-}" in
        y|Y|yes|Yes|YES)
            echo true
            ;;
        n|N|no|No|NO)
            echo false
            ;;
        *) 
            echo -1
            ;;
    esac
}

# 询问安装信息
install() {
    eval "$invocation"

    # 确认最低需求
    check_min_reqs
    # 默认安装DDTV
    if [ -e "$DDTV_install_dir/$DDTV_full_name.dll" ]; then
        echo "        0. 已安装 $DDTV_full_name 。"
    else
        echo "        0. 将安装 $DDTV_full_name 。"
        is_exec_DDTV_cmd=true
    fi

    # 确认安装dotnet
    if dotnet_has_been_installed; then
        echo "        1. 已安装 dotnet 。"
    else
        while [[ $is_exec_dotnet_cmd == -1 ]]; do
            echo -n "        1. 是否安装 dotnet (y/n): "
            read -r -e yn
            is_exec_dotnet_cmd="$(yn_to_tf "$yn")"
        done
    fi

    if [[ "$_sudo" != " " ]]; then
    # 确认尝试安装依赖
        while [[ $is_exec_deps_cmd == -1 ]] && ! dotnet_has_been_installed; do
            echo -n "        2. 是否尝试安装 dotnet 依赖 (y/n): "
            read -r -e yn
            is_exec_deps_cmd="$(yn_to_tf "$yn")"
        done

    # 确认安装ffmpeg
        if machine_has "ffmpeg"; then
            echo "        3. 已安装 ffmpeg 。"
        else
            while [[ $is_install_ffmpeg == -1 ]]; do
                echo -n "        3. 是否尝试安装 ffmpeg (y/n): "
                read -r -e yn
                is_install_ffmpeg="$(yn_to_tf "$yn")"
            done
        fi

    # 确认安装service
        if machine_has "systemctl"; then
            if [ -e "/lib/systemd/system/$DDTV_short_name.service" ]; then
                echo "        4. 已将 DDTV 写入服务。"
            else
                while [[ $is_exec_service_cmd == -1 ]]; do
                    echo -n "        4. 是否将 DDTV 写入服务并加入自启 (y/n): "
                    read -r -e yn
                    is_exec_service_cmd="$(yn_to_tf "$yn")"
                done
            fi
        else
            is_exec_service_cmd=false && echo "        4. 系统无 systemctl 命令，已跳过将 DDTV 写入服务。"
        fi
    else
        is_exec_deps_cmd=false        && echo "        2. 当前为用户无 sudo 权限，已跳过安装 依赖 与 ffmpeg 。"
        is_exec_service_cmd=false     && echo "        3. 当前为用户无 sudo 权限，已跳过将 DDTV 写入服务。"
    fi
}

# 询问卸载信息
uninstall() {
    eval "$invocation"

    # 确认卸载DDTV
    if [ ! -e "$DDTV_install_dir" ]; then
        echo "        0. 已卸载 $DDTV_full_name 。"
    else
        while [[ $is_exec_DDTV_cmd == -1 ]]; do
            echo -n "        0. 是否卸载 $DDTV_full_name ，这将删除配置文件(y/n): "
            read -r -e yn
            is_exec_DDTV_cmd="$(yn_to_tf "$yn")"
        done
    fi

    # 确认卸载dotnet
    if ! dotnet_has_been_installed; then
        echo "        1. dotnet 未检测到。"
    else
        while [[ $is_exec_dotnet_cmd == -1 ]]; do
            echo -n "        1. 是否卸载 dotnet (y/n): "
            read -r -e yn
            is_exec_dotnet_cmd="$(yn_to_tf "$yn")"
        done
    fi

    # 默认不卸载依赖
    is_exec_deps_cmd=false            && echo "        2. 默认不卸载 dotnet 依赖。"
    if [ -e "/lib/systemd/system/$DDTV_short_name.service" ]; then
        # 确认卸载service
        while [[ $is_exec_service_cmd == -1 ]]; do
           echo -n "        3. 是否将 DDTV 从服务中删除 (y/n): "
            read -r -e yn
            is_exec_service_cmd="$(yn_to_tf "$yn")"
        done
    else
        is_exec_service_cmd=false     && echo "        3. 未安装服务。"
    fi
}

#=确认安装卸载信息====================#
echo "${yellow:-}$(date)${normal:-}" > $logfile
$is_install && anvl="安装" || anvl="卸载"
# 检测环境
DDTV_install_dir=${DDTV_install_dir:-"$HOME/.DDTV"}
if [[ $exec_mode != "user" ]] && has_sudo; then
# 有 sudo 且是 package root 模式
    if ! check_package && [[ $exec_mode != "root" ]]; then # 检测包管理器
        exec_mode="root" # 没有则安装\卸载二进制文件
        say_warning "已根据系统环境切换到 root 模式。"
    fi
    dotnet_install_dir=${dotnet_install_dir:-"/usr/share/dotnet"}
else
# 没有 sudo 或指定了 user 模式
    exec_mode="user" # 没有则安装\卸载到$HOME目录
    [[ "$_sudo" == " " ]] && say_warning "无管理员权限，切换到 user 模式。"
    dotnet_install_dir=${dotnet_install_dir:-"$HOME/.dotnet"}
fi

# 不带参数运行，执行询问
if [[ $is_exec_deps_cmd == -1 && $is_exec_dotnet_cmd == -1 && $is_exec_service_cmd == -1 && $is_exec_DDTV_cmd == -1 ]]; then
    echo ""
    echo "    本脚本 ($script_name) 用于安装、卸载 ${DDTV_full_name} 。"
    echo ""
    echo "    在脚本执行之前，请先确认以下问题:"
    if [[ $is_install == true ]]; then install; else uninstall; fi
elif [[ $is_install == true ]]; then
    # 确认最低需求
    check_min_reqs
fi
    echo ""
    echo "    执行模式: ${yellow:-}$exec_mode${normal:-}"
    echo "    将会${anvl}:"
    [[ $is_exec_deps_cmd == true ]]    && echo -e "\t- ${cyan:-}相关依赖${normal:-}"
    [[ $is_exec_service_cmd == true ]] && echo -e "\t- ${cyan:-}服务${normal:-}"
    [[ $is_install_ffmpeg == true ]]   && echo -e "\t- ${cyan:-}ffmpeg${normal:-}"
    [[ $is_exec_dotnet_cmd == true ]]  && echo -e "\t- ${cyan:-}dotnet ${dotnet_version[0]} ${normal:-}路径: \"$dotnet_install_dir\""
    [[ $is_exec_DDTV_cmd == true ]]    && echo -e "\t- ${cyan:-}$DDTV_full_name $DDTV_version ${normal:-}路径: \"$DDTV_install_dir\""
    echo -e "\t更新 $DDTV_full_name 至最新构建"
while true; do
    echo -n "    请确认 (y/n): "
    read -r -e yn
    yn=$(yn_to_tf "$yn")
    case $yn in
        true)   break
                ;;
        false)  [[ "$is_need_log" == false ]] && rm -f $logfile && exit 0
                ;;
    esac
done
    echo ""

#=Debug信息====================#
say_verbose "系统: ${ID:-"未知"}${VERSION_ID:+" $VERSION_ID"} | 执行用户: $uname | 安装/卸载: $anvl | 模式: $exec_mode | 下载工具: ${download:0:4} | 支持的 dotnet 包管理器: $supported_dotnet_package | 代理: ${PROXY:-"无"}"
say_verbose "exec_deps_cmd: $is_exec_deps_cmd | exec_dotnet_cmd: $is_exec_dotnet_cmd | exec_DDTV_cmd: $is_exec_DDTV_cmd | exec_service_cmd: $is_exec_service_cmd | install_ffmpeg: $is_install_ffmpeg"
[[ $is_exec_deps_cmd    == true ]] && say_verbose "将执行 deps    命令"
[[ $is_exec_dotnet_cmd  == true ]] && say_verbose "将执行 dotnet  命令 | 版本: ${dotnet_version[0]} | 架构: $architecture  | 路径: $dotnet_install_dir"
[[ $is_exec_DDTV_cmd    == true ]] && say_verbose "将执行 DDTV    命令 | 版本: ${DDTV_version} | 路径: $DDTV_install_dir"
[[ $is_exec_service_cmd == true ]] && say_verbose "将执行 service 命令"
[[ $is_verbose == true ]] && echo ""

#=执行安装卸载命令====================#
deps_command="say '依赖 尝试${anvl}中...'" && dotnet_command="say 'dotnet ${anvl}中...'" && service_command="say '服务 ${anvl}中...'" && DDTV_command="say '${DDTV_full_name} ${anvl}中...'"

[[ $is_exec_deps_cmd    == true ]] && if    deps_command+=$(if $is_install; then install_deps   ; else uninstall_deps   ; fi) && say_verbose "依赖 执行命令: $deps_command"     && eval "$deps_command"    ; then say "依赖 ${anvl}成功! "   ; else failed+=" deps"    ; say_err "依赖 ${anvl}命令执行失败。"   ; fi
[[ $is_exec_dotnet_cmd  == true ]] && if  dotnet_command+=$(if $is_install; then install_dotnet ; else uninstall_dotnet ; fi) && say_verbose "dotnet 执行命令: $dotnet_command" && eval "$dotnet_command"  ; then say "dotnet ${anvl}成功! " ; is_suitable_dotnet=true ; else failed+=" dotnet"  ; say_err "dotnet ${anvl}命令执行失败。" ; fi
[[ $is_exec_DDTV_cmd    == true ]] && if    DDTV_command+=$(if $is_install; then install_DDTV   ; else uninstall_DDTV   ; fi) && say_verbose "DDTV 执行命令: $DDTV_command"     && eval "$DDTV_command"    ; then say "DDTV ${anvl}成功! "   ; else failed+=" DDTV"    ; say_err "DDTV ${anvl}命令执行失败。"   ; fi
[[ $is_exec_service_cmd == true ]] && if service_command+=$(if $is_install; then install_service; else uninstall_service; fi) && say_verbose "服务 执行命令: $service_command"  && eval "$service_command" ; then say "服务 ${anvl}成功! "   ; else failed+=" service" ; say_err "服务 ${anvl}命令执行失败。"   ; fi

# 更新 DDTV
if dotnet_has_been_installed && [ -e "$DDTV_install_dir/DDTV_Update.dll" ]; then
    cd $DDTV_install_dir && $dotnet_install_dir/dotnet $DDTV_install_dir/DDTV_Update.dll docker
fi

# 输出安装完成信息
say "${anvl}执行完成。"
if [[ $is_install == true ]]; then
    echo ""
    if [[ "$failed" != *"dotnet"* && $is_exec_dotnet_cmd == true ]] ; then echo "    dotnet 路径: $dotnet_install_dir" ; fi
    if [[ "$failed" != *"DDTV"*   && $is_exec_DDTV_cmd   == true ]] ; then echo "    $DDTV_full_name 路径: $DDTV_install_dir" ; fi
    if [[ "$failed" != *"DDTV"*   && $is_exec_DDTV_cmd   == true ]] ; then
        if   [[ $is_suitable_dotnet == true ]]                      ; then
            echo "    $DDTV_short_name 运行方式: dotnet $DDTV_install_dir/$DDTV_full_name.dll"
            echo "    $DDTV_short_name 更新方式: dotnet $DDTV_install_dir/DDTV_Update.dll 或 重新运行此脚本"
        elif [[ $is_exec_dotnet_cmd == true ]]                      ; then
            echo "    $DDTV_short_name 运行方式: $dotnet_install_dir/dotnet $DDTV_install_dir/$DDTV_full_name.dll"
            echo "    $DDTV_short_name 更新方式: $dotnet_install_dir/dotnet $DDTV_install_dir/DDTV_Update.dll 或 重新运行此脚本"
        fi
    fi

    if [[ "$failed" != *"service"* && $is_exec_service_cmd == true  ]] ; then
        echo -e "\n    $DDTV_full_name 服务命令:"
        echo -e "\t启动:${_sudo}systemctl start $DDTV_short_name\t\t查询状态:${_sudo}systemctl status $DDTV_short_name"
        echo -e "\t停止:${_sudo}systemctl stop $DDTV_short_name\t\t加入自启:${_sudo}systemctl enable $DDTV_short_name"
        echo -e "\t重启:${_sudo}systemctl restart $DDTV_short_name\t\t停止自启:${_sudo}systemctl disable $DDTV_short_name"
    fi
    

# 输出安装失败信息
    echo ""
    if [[ "$failed" == *"dotnet"* ]] && [ -e "dotnet-install.sh" ]      ; then say_warning "dotnet 安装失败，请自行执行 \"${_sudo}./dotnet-install.sh -c ${dotnet_version[0]} -i $dotnet_install_dir --runtime aspnetcore\"" ; fi
    if [[ "$failed" == *"dotnet"* || $is_exec_dotnet_cmd == false  ]]   ; then say_warning "请参考微软文档安装 \".NET${dotnet_version[0]} SDK\" 或 \"ASP.NET Core与.NET Core 运行时(${dotnet_version[0]})\": https://docs.microsoft.com/zh-cn/dotnet/core/install/linux 。" ; fi
    if [[ "$failed" == *"deps"*   || $is_exec_deps_cmd   == false    ]] ; then say_warning "请参考微软文档安装 dotnet 依赖: https://docs.microsoft.com/zh-cn/dotnet/core/install/linux-scripted-manual#dependencies 。" ; fi
    if [[ "$failed" == *"deps"*   || $is_exec_deps_cmd   == false    ]] ; then say_warning "请安装 $DDTV_full_name 依赖（参考上述微软文档）: libgdiplus (版本 6.0.1 或更高版本)。" ; fi
fi
# [[ $is_install == false && $is_exec_deps_cmd == false && $supported_dotnet_package == false ]] && say "依赖未卸载，有需要请运行 \"./$script_name --uninstall deps\""

# 输出失败信息
if [[ "$failed" == *"ffmpeg"* ]]; then
    say_warning "当前包存储库未有 ffmpeg ，请自行${anvl}。"
fi

if [[ "$failed" != false ]]; then
    say_err "脚本执行存在失败，请查看终端输出重新${anvl}！"
    say_err "或反馈debug日志（$PWD/$logfile）！"
    is_need_log=true
fi

[[ "$is_need_log" == false ]] && rm -f $logfile
rm -rf "${temporary_file_template%%.*}".*


# 孩子的第一个脚本，拿来练手的（，像 set -e 、双引号与单引号在$() eval中的作用区别 等没考虑到，看到奇葩代码请控制好血压（