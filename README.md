# Docker-DDTVLiveRec

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtvliverec?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/docker-ddtvliverec/DDTV_WEB_Server_Docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/docker-ddtvliverec/actions/workflows/DDTV_WEB_Server_Docker.yml)
[![浏览人数统计](https://s04.flagcounter.com/mini/xztG/bg_FFFFFF/txt_000000/border_FFFFFF/flags_0/)](http://s04.flagcounter.com/more/xztG)

本项目使用Github Actions自动构建，以[mcr.microsoft.com/dotnet/aspnet](https://hub.docker.com/_/microsoft-dotnet-aspnet)为基础镜像，将DDTVLiveRec的发行版及ffmpeg，打包并上传至[DockerHub](https://hub.docker.com/r/moomiji/ddtvliverec)和[ghcr.io](https://github.com/users/moomiji/packages/container/package/ddtvliverec)。

| OS | Tag | OS Version  | Supported Platform |
| ---- | ---- | ---- | ---- |
| Alpine | `latest` `Version` | Alpine 3.14 | `amd64` `arm64v8` `arm32v7` |
| Debian | `latest-debian` `Version-debian` | Debian 11 | `amd64` `arm64v8` `arm32v7` |

（截至2022/2/16）

## 更新镜像

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtvliverec?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/docker-ddtvliverec/DDTV_WEB_Server_Docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/docker-ddtvliverec/actions/workflows/DDTV_WEB_Server_Docker.yml)

若上面两个蓝黑色徽章的版本不同，在github中Star[本项目](https://github.com/moomiji/Docker-DDTVLiveRec)进行自动更新，在[Action](https://github.com/moomiji/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)中查看进度。

## 使用方法（推荐第4个）

镜像名`moomiji/ddtvliverec`可替换成`ghcr.io/moomiji/ddtvliverec`，如果DockerHub下载不畅的话。

1. 尝鲜使用

```shell
docker volume create DDTV_Rec
docker run -itd -p 11419:11419 -v DDTV_Rec:/DDTV/Rec --name DDTV_WEB_Server moomiji/ddtvliverec:latest
```

~~访问`http://IP:11419`进入DDTV_WEB_Server，默认用户名`ami`，默认密码`ddtv`。~~

~~访问`http://IP:11419/loginqr`以扫码登录B站账号。~~

删除容器

```shell
docker stop ddtv 
docker rm ddtv
docker volume rm DDTV_Rec
```

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
    -v ${DOWNLOAD_DIR}:/DDTV/Rec \
    --name DDTV_WEB_Server \
    moomiji/ddtvliverec:latest
```

3. 单独挂载配置好的配置文件

- `RoomListConfig.json` 存在时，变量 `roomlist` 不起作用。

- `DDTV_Config.ini` 存在时，除 `PUID` `PGID` `roomlist` 外的其他变量不起作用。

准备好一个目录放入 `DDTV_Config.ini` `BiliUser.ini` `RoomListConfig.json` 。

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v ${DOWNLOAD_DIR}:/DDTV/Rec \
    -v ${CONFIG_DIR}/BiliUser.ini:/DDTV/BiliUser.ini \
    -v ${CONFIG_DIR}/DDTV_Config.ini:/DDTV/DDTV_Config.ini \
    -v ${CONFIG_DIR}/RoomListConfig.json:/DDTV/RoomListConfig.json \
    --name DDTV_WEB_Server \
    moomiji/ddtvliverec:latest
```

4. 将某一目录挂载至容器内的DDTV目录

- `RoomListConfig.json` 存在时，变量 `roomlist` 不起作用。

- `DDTV_Config.ini` 存在时，除 `PUID` `PGID` `roomlist` 外的其他变量不起作用。

准备好一个目录放入（或不放入） `DDTV_Config.ini` `BiliUser.ini` `RoomListConfig.json` 。

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v ${DOWNLOAD_DIR}:/DDTV/Rec \
    -v ${CONFIG_DIR}:/DDTV
    --name DDTV_WEB_Server \
    moomiji/ddtvliverec:latest
```

**！！！不要挂载不存在的文件，不存在的话docker默认创建的是目录不是文件！！！**

正确做法是挂载空的配置文件！（使用`touch filename`命令创建空文件）

0. docker常用命令

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

## 配置文件如何准备

| 文件名 | 获得方法 |
| ----  | ----  |
| BiliUser.ini  | 从配置好的 DDTV GUI 的目录下复制  |
| DDTV_Config.ini | 从配置好的 DDTV GUI 的目录下复制 |
| RoomListConfig.json  | 从配置好的 DDTV GUI 的目录下复制 |

- 详见：[官网配置说明](https://ddtv.pro/config/)

## 常用的环境变量

| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| PUID | `num` | `0` | 用户ID |
| PGID | `num` | `0` | 用户组ID |
| TZ | `州/城市` | `Asia/Shanghai` | 时区 |
| roomlist | `json` | `{"data":[]}` | [官网说明](https://ddtv.pro/config/RoomListConfig.json.html)，请压缩至一行或使用 `\` 换行 |
| RoomListConfig | 路径 | `./RoomListConfig.json` | 房间配置文件路径 |
| DownloadDirectoryName | `{KEY}_{KEY}` | `{ROOMID}_{NAME}` | 默认下载文件夹名字格式 |
| DownloadFileName | `{KEY}_{KEY}` | `{DATE}_{TIME}_{TITLE}` | 默认下载文件名格式 |
| TranscodParmetrs | ffmpeg 参数 带 `{After}` `{Before}` | `-i {Before} -vcodec copy -acodec copy {After}` | 转码默认参数 |
| IsAutoTranscod | `bool` | `false` | 启用自动转码 |
| WEB_API_SSL | `bool` | `false` | 启用WEB_API加密证书 |
| pfxFileName | 路径 |   | pfx证书文件路径 |
| pfxPasswordFileName | 路径 |   | pfx证书秘钥文件路径 |
| RecQuality | `int` | `10000` | 录制分辨率，可选值：流畅:80  高清:150  超清:250  蓝光:400  原画:10000 |
| IsRecDanmu | `bool` | `true` | 全局弹幕录制开关 |
| IsRecGift | `bool` | `true` | 全局礼物录制开关 |
| IsRecGuard | `bool` | `true` | 全局上舰录制开关 |
| IsRecSC | `bool` | `true` | 全局SC录制开关 |
| IsFlvSplit | `bool` | `false` | 全局FLV文件按大小切分开关，注：启动后自动合并、自动转码时效 |
| FlvSplitSize | `long int` | `1073741824` | FLV文件切分的大小(byte) |
| WebUserName | `string` | `ami` | WEB登陆使用的用户名 |
| WebPassword | `string` | `ddtv` | WEB登陆使用的密码 |

- 注：变量值太奇怪要转义哟（使用`\`转义）

更多变量详见[官网 Core 配置文件说明](https://ddtv.pro/config/DDTV_Config.html)。

## 其他镜像

- [zzcabc的ddtv项目](https://hub.docker.com/r/zzcabc/ddtv)

- [uchuhimo的ddtv_live_rec项目](https://hub.docker.com/r/uchuhimo/ddtv_live_rec)
