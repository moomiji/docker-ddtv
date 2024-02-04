# DDTV_Docker版使用教程（Linux）

Docker 镜像在 [Docker Hub](https://hub.docker.com/u/ddtv) 和 [GitHub Container registry](https://github.com/CHKZL?tab=packages&repo_name=DDTV) 上提供。

两个位置提供的镜像完全一样，都是对 DDTV 发行版本的简单包装。

## 先决条件
  - Linux
  - 容器引擎，如 Docker-ce 18.03 或更高版本 ([安装教程](https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/))、Podman 等

#### 镜像名

| Docker 项目名 | GHCR 镜像名 | Docker Hub 镜像名 |
| :---- | :---- | :---- |
| DDTV_CLI | ghcr.io/chkzl/ddtv/cli | ddtv/cli |

#### CLI 支持的架构及可用标签

| 系统 \ 架构 | amd64 | arm64v8 | arm32v7 | 可用标签 |
| :---- | :----: | :----: | :----: | :---- |
| debian | ✅ | ✅ | ✅ | `latest` `debian` `5.0` `5.0.*.*` |

## 最佳实践

## docker cli 运行容器

#### 运行 DDTV_CLI

```shell
sudo docker run -d -p 11419:11419     \ # \后面不能有字符
        -v ${PWD}/DDTV_Rec:/DDTV/Rec  \ # 持久化录制文件
        -v ${CONFIG_DIR}:/DDTV/Config \ # 持久化配置文件
        -e PUID=$(id -u)           \
        -e PGID=$(id -g)           \
        --name DDTV_CLI               \
        ghcr.io/chkzl/ddtv/cli
# 删除容器
sudo docker rm -f DDTV_CLI
```

## 可用环境变量

#### Docker 版独有环境变量

| 参数名 | 格式 | 默认值 | 说明 | 可用镜像 |
| ---- | ---- | ---- | ---- | ---- |
| TZ | `州/城市` | `Asia/Shanghai` | 时区 | `cli` |
| PUID | `num` | `0` | 运行 DDTV 的用户 ID | `cli` |
| PGID | `num` | `0` | 运行 DDTV 的用户组 ID | `cli` |

#### CLI 配置文件常用环境变量

参数名与[DDTV Core通用配置文件](/config/DDTV_Config.html)的配置名完全相同。

| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| RoomListConfig | 路径 | `./RoomListConfig.json` | RoomListConfig.json文件位置 |
| IsHls | `bool` | `True` | 是否优先使用HLS进行录制 |
| IsDev | `bool` | `False` | 是否使用开发版更新模式 |
| IsAutoTranscod | `bool` | `False` | 是否启用自动转码 |
| IsFlvSplit | `bool` | `False` | 是否启用全局FLV文件按大小切分开关，注：启动后自动合并、自动转码失效 |
| FlvSplitSize | `longint` | `1073741824` | 文件切分的大小(byte) |
| WebUserName | `string` | `ami` | WEB登陆使用的用户名 |
| WebPassword | `string` | `ddtv` | WEB登陆使用的密码 |
| Shell | `bool` | `False` | 用于控制下载完成后是否执行对应房间的Shell命令 |
| WebHookUrl | `string` | `string.Empty` | WebHook的目标地址 |

更多可用变量见 [官网配置说明](/config/DDTV_Config.html#配置说明) 与 [docker-ddtv.env](https://github.com/moomiji/docker-ddtv/blob/docker/docker-ddtv.env)。

## CLI 可用运行参数

```shell
sudo docker run  \
     ...         \
     镜像[:标签] \
     --no-update \ # 容器重启后不自动更新 DDTV
     --verbose   \ # 脚本输出更多信息
```
