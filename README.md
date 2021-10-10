# Docker-DDTVLiveRec

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtvliverec?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/Docker-DDTVLiveRec/DDTVLiveRec_docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)
[![浏览人数统计](https://s04.flagcounter.com/mini/xztG/bg_FFFFFF/txt_000000/border_FFFFFF/flags_0/)](http://s04.flagcounter.com/more/xztG)

本项目使用Github Actions自动构建，以[mcr.microsoft.com/dotnet/aspnet](https://hub.docker.com/_/microsoft-dotnet-aspnet)为基础镜像，将DDTVLiveRec的发行版及ffmpeg，打包并上传至[DockerHub](https://hub.docker.com/r/moomiji/ddtvliverec)和[ghcr.io](https://github.com/users/moomiji/packages/container/package/ddtvliverec)。

| OS | Tag | OS Version  | Supported Platform |
| ---- | ---- | ---- | ---- |
| Alpine | `latest` `Version` | Alpine 3.14 | `amd64` `arm64v8` `arm32v7` |
| Debian | `latest-debian` `Version-debian` | Debian 10 | `amd64` `arm64v8` `arm32v7` |

（截至2021/9/23）

## 更新镜像

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/moomiji/ddtvliverec?label=DockerHub&sort=semver&style=flat-square)](https://hub.docker.com/r/moomiji/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/moomiji/Docker-DDTVLiveRec/DDTVLiveRec_docker?label=Docker%20Build&style=flat-square)](https://github.com/moomiji/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)

若上面两个蓝黑色徽章的版本不同，在github中Star[本项目](https://github.com/moomiji/Docker-DDTVLiveRec)进行自动更新，在[Action](https://github.com/moomiji/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)中查看进度。

## 使用方法

镜像名`moomiji/ddtvliverec`可替换成`ghcr.io/moomiji/ddtvliverec`，如果DockerHub下载不畅的话。

1. 尝鲜使用

```shell
docker volume create ddtv_data
docker run -itd -p 11419:11419 -v ddtv_data:/DDTVLiveRec/tmp --name ddtv moomiji/ddtvliverec:latest
```
访问`http://IP:11419`进入DDTVLiveRec，默认用户名`ami`，默认密码`ddtv`。

访问`http://IP:11419/loginqr`以扫码登录B站账号。

删除容器

```shell
docker stop ddtv && docker rm ddtv
docker volume create ddtv_data
```

2. 一般配置

设置`用户名` `密码` `PUID` `PGID` `RoomListConfig.json(建议保存)` `挂载目录`

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e WebUserName=ami \
    -e WebPassword=ddtv \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v ${DOWNLOAD_DIR}/RoomListConfig.json:/DDTVLiveRec/RoomListConfig.json \
    -v ${DOWNLOAD_DIR}:/DDTVLiveRec/tmp \
    --name ddtv \
    moomiji/ddtvliverec:latest
```

3. 使用配置好的配置文件

```shell
docker run -itd \
    --restart always \
    -p 11419:11419 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v ${DOWNLOAD_DIR}:/DDTVLiveRec/tmp \
    -v ${CONFIG_DIR}/BiliUser.ini:/DDTVLiveRec/BiliUser.ini \
    -v ${CONFIG_DIR}/DDTVLiveRec.dll.config:/DDTVLiveRec/DDTVLiveRec.dll.config \
    -v ${CONFIG_DIR}/RoomListConfig.json:/DDTVLiveRec/RoomListConfig.json \
    --name ddtv \
    moomiji/ddtvliverec:latest
```

**！！！不要挂载不存在的文件，不存在的话docker默认创建的是目录不是文件！！！**

正确做法是挂载空的配置文件（使用`touch filename`命令创建空文件），脚本会自动写入！

4. docker常用命令

- 查看日志

```shell
docker logs -f ddtv
```

- 获取容器文件

```shell
docker ps -a
docker cp  [CONTAINER ID]:/DDTVLiveRec/RoomListConfig.json .
```

## 配置文件如何准备

| 文件名 | 获得方法 |
| ----  | ----  |
| RoomListConfig.json  | 从配置好的DDTV的目录下复制 |
| BiliUser.ini  | 从配置好的DDTV的目录下复制  |
| DDTVLiveRec.dll.config  | 编辑[DDTVLiveRec.zip](https://github.com/CHKZL/DDTV2/releases/latest)中的DDTVLiveRec.dll.config文件 |

当然，无特殊需求（如续用配置）可以挂载空的配置文件（使用`touch filename`命令创建空文件）

## 常用的环境变量

| 参数名 | 格式 | 说明 | 位于 |
| ---- | ---- | ---- | ---- |
| PUID | `num` | 用户ID | 用于运行程序，解决下载文件权限问题 |
| PGID | `num` | 用户组ID | 用于运行程序，解决下载文件权限问题 |
| apiUrl | `http(s)://you.host:port` | 开启API | static/config.js |
| mount | `/path` | 只展示该目录下挂载的硬盘 | static/config.js |
| ApiToken | `str` | APIToken | DDTVLiveRec.dll.config |
| WebUserName | `str` | WEB详情页账号 | DDTVLiveRec.dll.config |
| WebPassword | `str` | WEB详情页密码 | DDTVLiveRec.dll.config |
| LiveRecWebServerDefaultIP | `*.*.*.*` | WEB详情页IP地址 | DDTVLiveRec.dll.config |
| Port | `num` | WEB详情页端口 | DDTVLiveRec.dll.config |
| AutoTranscoding | `1`开启 \ `0`关闭（默认） | 自动转码（会消耗大量CPU资源） | DDTVLiveRec.dll.config |
| RecordDanmu | `1`开启 \ `0`关闭（默认） | 录制弹幕信息(可能导致房间监控失效，建议只放目标房间) | DDTVLiveRec.dll.config |

- 注：变量值太奇怪要转义哟（使用`\`转义）

- 再注：路径里必有`/`，所以sed命令已经调整为使用`|`分割了

其他变量详见[DDTVLiveRec.dll.config](https://github.com/CHKZL/DDTV2/blob/master/DDTVLiveRec/App.config)，虽然做了支持，但不保证能用和不出现bug（这种情况请不要使用docker了，根据[官网说明](https://ddtv.pro/install/DDTVLiveRecForLinux.html)进行安装，你的需求我暂时无能为力（（）。

## 其他镜像

- [zzcabc的ddtv项目](https://hub.docker.com/r/zzcabc/ddtv)

- [uchuhimo的ddtv_live_rec项目](https://hub.docker.com/r/uchuhimo/ddtv_live_rec)

- 拉取源项目源码进行构建，详见[源项目使用说明](https://github.com/CHKZL/DDTV2/tree/master/DDTVLiveRec#%E5%A6%82%E6%9E%9C%E4%BD%BF%E7%94%A8docker%E6%9E%84%E5%BB%BA)、[官网说明](https://ddtv.pro/install/Docker.html)
