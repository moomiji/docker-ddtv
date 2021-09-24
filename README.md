# Docker-DDTVLiveRec

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/as737345039/ddtvliverec?label=DockerHub&style=flat-square)](https://hub.docker.com/r/as737345039/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/aS737345039/Docker-DDTVLiveRec/DDTVLiveRec_docker?label=Docker%20Build&style=flat-square)](https://github.com/aS737345039/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)

[源项目地址](https://github.com/CHKZL/DDTV2)　　[本项目地址](https://github.com/aS737345039/Docker-DDTVLiveRec)

本项目利用GitHub Action，以[mcr.microsoft.com/dotnet/aspnet](https://hub.docker.com/_/microsoft-dotnet-aspnet)为基础镜像，将DDTVLiveRec的发行版及ffmpeg，打包成Docker镜像，自动上传至[DockerHub](https://hub.docker.com/r/as737345039/ddtvliverec)。

支持的各架构及其基础镜像如下（截至2021/3/14）：

|  架构 | ASP.NET Tag | OS Version  | Dockerfile | Tag & Size |
| ---- | ---- | ---- | ---- | ---- |
| amd64  | 5.0-alpine | Alpine 3.13 | [Dockerfile](https://github.com/aS737345039/Docker-DDTVLiveRec/blob/dockerhub/DDTVLiveRec/Dockerfile.alpine) | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/as737345039/ddtvliverec/latest-amd64?label=latest-amd64&style=flat-square)](https://hub.docker.com/r/as737345039/ddtvliverec/tags?page=1&ordering=last_updated) |
| arm64v8  | 5.0-alpine | Alpine 3.13 | [Dockerfile](https://github.com/aS737345039/Docker-DDTVLiveRec/blob/dockerhub/DDTVLiveRec/Dockerfile.alpine) | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/as737345039/ddtvliverec/latest-arm64v8?label=latest-arm64v8&style=flat-square)](https://hub.docker.com/r/as737345039/ddtvliverec/tags?page=1&ordering=last_updated) |
| arm32v7  | 5.0 | Debian 10 | [Dockerfile](https://github.com/aS737345039/Docker-DDTVLiveRec/blob/dockerhub/DDTVLiveRec/Dockerfile.debian) | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/as737345039/ddtvliverec/latest-arm32v7?label=latest-arm32v7&style=flat-square)](https://hub.docker.com/r/as737345039/ddtvliverec/tags?page=1&ordering=last_updated) |

## 使用方法

### 1. 更新本镜像

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/CHKZL/DDTV2?label=DDTVLiveRec&style=flat-square)](https://github.com/CHKZL/DDTV2/releases/latest)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/as737345039/ddtvliverec?label=DockerHub&style=flat-square)](https://hub.docker.com/r/as737345039/ddtvliverec/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/aS737345039/Docker-DDTVLiveRec/DDTVLiveRec_docker?label=Docker%20Build&style=flat-square)](https://github.com/aS737345039/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)

- 若上面两个蓝黑色徽章的版本不同，在github中Star[本项目](https://github.com/aS737345039/Docker-DDTVLiveRec)进行自动更新，在[Action](https://github.com/aS737345039/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)中查看进度。

### 2. 准备文件（详见[源项目使用说明](https://github.com/CHKZL/DDTV2/tree/master/DDTVLiveRec#%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)）

- 注1：DDTVLiveRec.dll.config为DDTVLiveRec的配置文件，如果不需要`自动转码为MP4`与`储存弹幕信息`这两个功能，可以不需要配置该文件。

- 注2：DDTVLiveRec.dll.config的来源方式：①win下运行`DDTVLiveRec`后获取（MacOS不了解）；②linux或linux docker下运行`DDTVLiveRec`后获取。

|  文件名 | 文件来自 |
|  ----  | ----  |
|  RoomListConfig.json  | 配置好的DDTV目录 |
|  BiliUser.ini  | 配置好的DDTV目录  |
|  DDTVLiveRec.dll.config  | 配置好的DDTVLiveRec目录  |

### 3. 运行docker

- 注1：如果没有`DDTVLiveRec.dll.config`文件，请删去`-v ${CONFIG_DIR}/DDTVLiveRec.dll.config:/DDTVLiveRec/DDTVLiveRec.dll.config \`这行

- 注2：如果想从docker下获取`DDTVLiveRec.dll.config`文件，使用`docker exec -it ddtv /bin/sh`进入ddtv镜像后，`cp DDTVLiveRec.dll.config tmp`，在`${DOWNLOAD_DIR}`文件夹下找到`DDTVLiveRec.dll.config`文件

```dockerfile
docker run -d \
    --restart always \
    -p 11419:11419 \
    -v ${CONFIG_DIR}/BiliUser.ini:/DDTVLiveRec/BiliUser.ini \
    -v ${CONFIG_DIR}/DDTVLiveRec.dll.config:/DDTVLiveRec/DDTVLiveRec.dll.config \
    -v ${CONFIG_DIR}/RoomListConfig.json:/DDTVLiveRec/RoomListConfig.json \
    -v ${DOWNLOAD_DIR}:/DDTVLiveRec/tmp \
    --name ddtv \
    as737345039/ddtvliverec:latest
```

## 从源码构建

1. [zzcabc的ddtv项目](https://hub.docker.com/r/zzcabc/ddtv)；

2. [uchuhimo的ddtv_live_rec项目](https://hub.docker.com/r/uchuhimo/ddtv_live_rec);

3. 拉取源项目源码进行构建，详见[源项目使用说明](https://github.com/CHKZL/DDTV2/tree/master/DDTVLiveRec#%E5%A6%82%E6%9E%9C%E4%BD%BF%E7%94%A8docker%E6%9E%84%E5%BB%BA)。

# 对原项目作者的捐助
### 捐助表示您对我这个项目的认可，也能激励我继续开发更多好的项目

![生活](https://github.com/CHKZL/DDTV2/blob/master/DDTV_New/%E7%94%9F%E6%B4%BB.png)

* 支付宝

![支付宝](https://github.com/CHKZL/DDTV/blob/master/src/ZFB.png)
* 微信

![微信](https://github.com/CHKZL/DDTV/blob/master/src/WX.png)
