# Docker-DDTV

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV?label=DDTV&style=flat-square)](https://github.com/CHKZL/DDTV/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtv?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtv/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/docker-ddtv/DDTV_WEB_Server_Docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/docker-ddtv/actions/workflows/DDTV_WEB_Server_Docker.yml)
[![浏览人数统计](https://s04.flagcounter.com/mini/xztG/bg_FFFFFF/txt_000000/border_FFFFFF/flags_0/)](http://s04.flagcounter.com/more/xztG)

本项目使用Github Actions自动构建，以 `aspnet:alpine` `nginx:alpine` 为基础镜像，将DDTV的发行版及ffmpeg，打包并上传至 [DockerHub](https://hub.docker.com/r/moomiji/ddtv) 和 [ghcr.io](https://github.com/users/moomiji/packages/container/package/ddtv) 以及 registry.cn-shenzhen.aliyuncs.com 。

| Image | Tag | Registry  | Supported Platform |
| ---- | ---- | ---- | ---- |
| ddtv | `latest` `Version` | `DockerHub` `ghcr.io` `registry.cn-shenzhen.aliyuncs.com` | `amd64` `arm64v8` `arm32v7` |
| ddtvwebui | `latest` `Version` | `ghcr.io` `registry.cn-shenzhen.aliyuncs.com` | `amd64` `arm64v8` `arm32v7` |

## 更新镜像

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV?label=DDTV&style=flat-square)](https://github.com/CHKZL/DDTV/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtv?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtv/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/docker-ddtv/DDTV_WEB_Server_Docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/docker-ddtv/actions/workflows/DDTV_WEB_Server_Docker.yml)

若上面两个蓝黑色徽章的版本不同，在github中Star[本项目](https://github.com/moomiji/Docker-DDTV)进行自动更新，在[Action](https://github.com/moomiji/Docker-DDTV/actions/workflows/DDTV_docker.yml)中查看进度。

## webserver使用方法

可用镜像名: `moomiji/ddtv` `ghcr.io/moomiji/ddtv` `registry.cn-shenzhen.aliyuncs.com/moomiji/ddtv`。

建议使用第三种。

1. 尝鲜使用

```shell
docker volume create DDTV_Rec
docker run -itd -p 11419:11419 \
    -v DDTV_Rec:/DDTV/Rec \ # 当前版本暂未有前端，下面两个环境变量为必须，否则不能正常录制
    -e RoomList="${RoomList}" \ # 房间配置文件，详见 常用的环境变量
    -e BiliUser="${BiliUser}" \ # 用户本地加密缓存扫码登陆bilibili信息
    -e show=false \
    --name DDTV_WEB_Server moomiji/ddtv:latest
# 删除容器
docker stop DDTV_WEB_Server
docker rm DDTV_WEB_Server
docker volume rm DDTV_Rec
```

~~访问`http://IP:11419`进入DDTV_WEB_Server，默认用户名`ami`，默认密码`ddtv`。~~

~~访问`http://IP:11419/loginqr`以扫码登录B站账号。~~ 当前 DDTV_WEB_Server 版本暂内置前端，不能使用

2. 无需持久化配置文件

- 可使用更多的变量，见#常用的环境变量。

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e WebUserName=ami \
    -e WebPassword=ddtv \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e RoomList="${RoomList}" \ # 房间配置文件，详见 常用的环境变量
    -e BiliUser="${BiliUser}" \ # 用户本地加密缓存扫码登陆bilibili信息
    -e show=false \
    -v ${DOWNLOAD_DIR}:/DDTV/Rec \
    --name DDTV_WEB_Server \
    moomiji/ddtv:latest
```

3. 将某一目录挂载至容器内的DDTV目录

准备好一个目录放入（或不放入） `DDTV_Config.ini` `BiliUser.ini` `RoomListConfig.json` 。

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e show=false \
    -v ${DOWNLOAD_DIR}:/DDTV/Rec \
    -v ${CONFIG_DIR}:/DDTV
    --name DDTV_WEB_Server \
    moomiji/ddtv:latest
```

4. 运行可用参数

```shell
docker run moomiji/ddtv:latest --no-update # 不开启启动更新
```

## webui使用方法

可用镜像名: `ghcr.io/moomiji/ddtvwebui` `registry.cn-shenzhen.aliyuncs.com/moomiji/ddtvwebui`

1. 直接使用

```shell
docker run -d -p 8080:80 \
    -e apiUrl=${apiUrl} \ # 后端地址，如 http://127.0.0.1:11419
    -e mount=${mount} \   # 显示目录所在文件系统占用情况的目录，如 /
    -e show=false \
    --name DDTV_WEBUI ghcr.io/moomiji/ddtvwebui
```

- 完整配置（详见常用的环境变量）

```shell
docker run -d -p 8080:80 \
    -e apiUrl="${apiUrl}" \
    -e mount="${mount}" \
    -e show="${show}" \
    -e infoshow="${infoshow}" \
    -e infotext="${infotext}" \
    -e infolink="${infolink}" \
    -e ICPshow="${ICPshow}" \
    -e ICPtext="${ICPtext}" \
    -e ICPlink="${ICPlink}" \
    -e GAshow="${GAshow}" \
    -e GAtext="${GAtext}" \
    -e GAlink="${GAlink}" \
    --name DDTV_WEBUI ghcr.io/moomiji/ddtvwebui
```

2. 持久化前端配置文件

```shell
docker run -d -p 8080:80 \
    -v ${CONFIG_DIR}:/DDTV/static
  # -v ${CONFIG_DIR}/barinfo.js:/DDTV/static/barinfo.js
  # -v ${CONFIG_DIR}/config.js:/DDTV/static/config.js
    --name DDTV_WEBUI ghcr.io/moomiji/ddtvwebui
```

## 配置文件如何准备

| 文件名 | 获得方法 |
| ----  | ----  |
| BiliUser.ini  | 配置好的 DDTV GUI 目录下  |
| DDTV_Config.ini | 配置好的 DDTV GUI 目录下 |
| RoomListConfig.json  | 配置好的 DDTV GUI 目录下 |
| barinfo.js | 配置好的 DDTV UI  目录下 |
| config.js  | 配置好的 DDTV UI  目录下 |

- 详见：[官网配置说明](https://ddtv.pro/config/)

## 常用的环境变量

1. DDTV WEB Server 可用参数

除前三个变量 `PUID` `PGID` `TZ` 的其他变量只在 `配置文件不存在（未挂载）时` 可用。

变量值太奇怪要使用`\`转义，网址不用转义。

更多变量详见[官网 Core 配置文件说明](https://ddtv.pro/config/DDTV_Config.html)。

| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| PUID | `num` | `0` | 用户ID |
| PGID | `num` | `0` | 用户组ID |
| TZ | `州/城市` | `Asia/Shanghai` | 时区 |
| RoomList_Config_Path | 路径 | `./RoomListConfig.json` | RoomListConfig.json文件位置 |
| RoomList | `json` | `{"data":[]}` 来自文件 `RoomListConfig.json`  文件不存在时可用 | [官网说明](https://ddtv.pro/config/RoomListConfig.json.html)，食用方法：`RoomList='{"data":[]}'; -e RoomList="${RoomList}"` |
| BiliUser | `ini` | 来自文件 `BiliUser.ini` 文件不存在时可用 | 食用方法：`BiliUser='cookie=...  \n  ExTime=...'; -e BiliUser="${BiliUser}"` |
| IsAutoTranscod | `bool` | `false` | 启用自动转码 |
| TranscodParmetrs | ffmpeg 参数 带 `{After}` `{Before}` | `-i {Before} -vcodec copy -acodec copy {After}` | 转码默认参数 |
| DownloadDirectoryName | `{KEY}_{KEY}` | `{ROOMID}_{NAME}` | 默认下载文件夹名字格式 |
| DownloadFileName | `{KEY}_{KEY}` | `{DATE}_{TIME}_{TITLE}` | 默认下载文件名格式 |
| RecQuality | `int` | `10000` | 录制分辨率，可选值：流畅:80  高清:150  超清:250  蓝光:400  原画:10000 |
| IsRecDanmu | `bool` | `true` | 全局弹幕录制开关 |
| IsRecGift | `bool` | `true` | 全局礼物录制开关 |
| IsRecGuard | `bool` | `true` | 全局上舰录制开关 |
| IsRecSC | `bool` | `true` | 全局SC录制开关 |
| IsFlvSplit | `bool` | `false` | 全局FLV文件按大小切分开关，注：启动后自动合并、自动转码时效 |
| FlvSplitSize | `long int` | `1073741824` | FLV文件切分的大小(byte) |
| WEB_API_SSL | `bool` | `false` | 启用WEB_API加密证书 |
| pfxFileName | 路径 |   | pfx证书文件路径 |
| pfxPasswordFileName | 路径 |   | pfx证书秘钥文件路径 |
| WebUserName | `string` | `ami` | WEB登陆使用的用户名 |
| WebPassword | `string` | `ddtv` | WEB登陆使用的密码 |
| AccessControlAllowOrigin | `http(s)://you.host:port` | `*` | DDTV_WEB跨域设置路径，应为前端网址 |
| AccessControlAllowCredentials | `bool` | `true` | DDTV_WEB的Credentials设置 (布尔值) |

2. DDTV WEB UI 可用参数（当 WEB Server 内置了前端项目时，也可使用）

变量只在 `镜像第一次启动` 可用。

| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| PROXY_PASS | `http(s)://you.host:port` | `http://127.0.0.1:11419` | 需要反代的后端地址, apiUrl=false 时 WEBUI 从反代地址联系 WEBServer |
| apiUrl | `bool` `http(s)://you.host:port` | `http://127.0.0.1:11419` | 后端地址, 同源也请更换为主机IP, 需要反代请填 false |
| mount | 路径 | `/` | 展示目录所在文件系统占用 |
| show | `bool` | `true` | 是否显示 |
| infoshow | `bool` | `true` | 是否显示版权信息 |
| infotext | `string` |  | 版权信息 |
| infolink | `string` |  | 版权信息跳转链接 |
| ICPshow | `bool` | `true` | 是否显示TCP备案信息 |
| ICPtext | `string` |  | TCP备案信息 |
| ICPlink | `string` |  | TCP备案信息跳转链接 |
| GAshow | `bool` | `true` | 是否显示公网安备信息 |
| GAtext | `string` |  | 公网安备信息 |
| GAlink | `string` |  | 公网安备信息跳转链接 |

## docker常用命令

- 查看日志

```shell
docker logs DDTV_WEB_Server # 打印所有日志
docker logs -f DDTV_WEB_Server # 跟踪日志
```

- 获取容器文件

```shell
docker ps -a
docker cp [DDTV CONTAINER ID]:/DDTV/* .
```

## 其他镜像

- [zzcabc的ddtv项目](https://hub.docker.com/r/zzcabc/ddtv)

- [uchuhimo的ddtv_live_rec项目](https://hub.docker.com/r/uchuhimo/ddtv_live_rec)
