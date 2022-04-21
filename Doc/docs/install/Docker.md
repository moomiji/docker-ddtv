# DDTV Docker版安装教程（CLI/WEB_Server<!--WEBUI-->）

## 先决条件
  - Linux
  - Docker-ce 18.03 或更高版本 ([安装教程](https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/))

## 可用镜像
- 镜像名：

| DDTV Docker项目 | ghcr | 特点 |
| ---- | ---- | ---- |
| DDTV_CLI | ghcr.io/chkzl/ddtv/cli | 重启容器即可更新 DDTV |
| DDTV_WEB_Server | ghcr.io/chkzl/ddtv/webserver |  重启容器即可更新 DDTV |
| DDTV_Deps <sup>1</sup> | ghcr.io/chkzl/ddtv/deps | 支持`arm64v8`和`arm32v7`架构 |
<!-- | DDTV_WEBUI <sup>4</sup> | ghcr.io/chkzl/ddtv/deps | 特点 | -->

- CLI / WEB_Server 支持的架构及可用标签：

| 系统 \ 架构 | amd64 (x86-64) | arm64v8 | arm32v7 | 可用标签 |
| :----: | :----: | :----: | :----: | :----: |
| alpine <sup>2</sup> | ✔ | ✘ | ✘ | `alpine` `3.0-alpine` `3.0.*.*-alpine` |
| debian | ✔ | ✔ | ✔ | `latest` `debian` `3.0` `3.0.*.*` |

<sup>1：`DDTV_Deps`只含 `DDTV_CLI`和`DDTV_WEB_Server`的必须依赖。</sup>
<sup>2：受 DDTV 依赖的影响，目前 alpine arm 下 DDTV 的`日志功能`、`控制台打印二维码功能`无法使用，并因此存在内存泄露问题；若有需要，可使用`DDTV_Deps`运行 DDTV。</sup>
<!-- <sup>3：`DDTV_WEBUI`支持的架构为：`amd64`,`arm64v8`,`arm32v7`,`i386`,`arm32v6`,`ppc64le`,`s390x`</sup> -->

## 最佳实践

查阅修改`ddtv_docker.env`后运行

方法一：修改`docker-compose.yml`后自行运行

```
wget https://raw.githubusercontent.com/CHKZL/DDTV/master/Docker/ddtv_docker.env
vi ddtv_docker.env

wget https://raw.githubusercontent.com/CHKZL/DDTV/master/Docker/ddtv_docker.env
vi docker-compose.yml
> version: '3'
> services:
>   DDTV.service_name:
>     env_file:
>       - ddtv_docker.env
> ...
```

方法二：使用参数`--env-file`运行

- docker-compose
```
wget https://raw.githubusercontent.com/CHKZL/DDTV/master/Docker/ddtv_docker.env
vi ddtv_docker.env

wget https://raw.githubusercontent.com/CHKZL/DDTV/master/Docker/ddtv_docker.env
docker-compose --env-file ./ddtv_docker.env up
```

- docker run
```
wget https://raw.githubusercontent.com/CHKZL/DDTV/master/Docker/ddtv_docker.env
vi ddtv_docker.env
docker run --env-file=./ddtv_docker.env
```

## 命令行运行容器

1. 运行 DDTV_WEB_Server

```shell
sudo docker volume create DDTV_Rec
sudo docker run -itd -p 11419:11419 \ # \后面不能有字符
        -v DDTV_Rec:/DDTV/Rec       \ # 必须，无论是挂载卷还是文件夹，否则会挂载匿名卷；持久化录制文件
        -v ${CONFIG_DIR}:/DDTV      \ # 可选，持久化 DDTV_WEB_Server 与 配置文件
        -e PUID=$(id -u)            \
        -e PGID=$(id -g)            \
        --name DDTV_WEB_Server      \
        ghcr.io/chkzl/ddtv/webserver
# 删除容器
sudo docker rm -f DDTV_WEB_Server
# 删除录制文件
sudo docker volume rm DDTV_Rec
```

2. 运行 DDTV_CLI

```shell
sudo docker volume create DDTV_Rec
sudo docker run -itd -p 11419:11419 \ # \后面不能有字符
        -v DDTV_Rec:/DDTV/Rec       \ # 必须，无论是挂载卷还是文件夹，否则会挂载匿名卷；持久化录制文件
        -v ${CONFIG_DIR}:/DDTV      \ # 可选，持久化 DDTV_CLI 与 配置文件
        -e PUID=$(id -u)            \
        -e PGID=$(id -g)            \
        --name DDTV_CLI             \
        ghcr.io/chkzl/ddtv/cli
# 删除容器
sudo docker rm -f DDTV_CLI
# 删除录制文件
sudo docker volume rm DDTV_Rec
```

3. 在 DDTV_Deps 中运行 CLI 或 WEB_Server

```shell
Project=CLI
Project=WEB_Server
wget  https://github.com/CHKZL/DDTV/releases/latest/download/DDTV_${Project}.zip
unzip DDTV_${Project}.zip
mv    DDTV_${Project} DDTV
cat   启动说明.txt && rm 启动说明.txt
sudo docker run -itd -p 11419:11419 \ # \后面不能有字符
        -v ${Rec_DIR}:/DDTV/Rec     \ # 可选，持久化录制文件
        -v ${PWD}/DDTV:/DDTV        \ # 必选，挂载 DDTV 目录
        -e PUID=$(id -u)            \
        -e PGID=$(id -g)            \
        --name DDTV_${Project}      \
        ghcr.io/chkzl/ddtv/deps:latest-alpine "cd /DDTV && dotnet DDTV_${Project}.dll"
```
待测试

## 可用环境变量

- DDTV docker 版独有变量
| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| PUID | `num` | `0` | 用户ID |
| PGID | `num` | `0` | 用户组ID |
| TZ | `州/城市` | `Asia/Shanghai` | 时区 |
| RoomList<sup>4</sup> | `json` | `{"data":[]}` 来自文件 `RoomListConfig.json`  文件不存在时可用 | [官网说明](https://ddtv.pro/config/RoomListConfig.json.html)，食用方法：`RoomList='{"data":[]}'; -e RoomList="${RoomList}"` |
| BiliUser<sup>4</sup> | `ini` | 来自文件 `BiliUser.ini` 文件不存在时可用 | 食用方法：`BiliUser='cookie=...  \n  ExTime=...'; -e BiliUser="${BiliUser}"` |

- DDTV CLI/WEB_Server 配置文件常用变量<sup>4</sup>
| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| RoomListConfig | 路径 | `./RoomListConfig.json` | RoomListConfig.json文件位置 |
| IsAutoTranscod | `bool` | `false` | 启用自动转码 |
| IsRecDanmu | `bool` | `true` | 全局弹幕录制开关 |
| IsRecGift | `bool` | `true` | 全局礼物录制开关 |
| IsRecGuard | `bool` | `true` | 全局上舰录制开关 |
| IsRecSC | `bool` | `true` | 全局SC录制开关 |
| IsFlvSplit | `bool` | `false` | 全局FLV文件按大小切分开关，注：启动后自动合并、自动转码时效 |
| FlvSplitSize | `long int` | `1073741824` | FLV文件切分的大小(byte) |
| WebUserName | `string` | `ami` | WEB登陆使用的用户名 |
| WebPassword | `string` | `ddtv` | WEB登陆使用的密码 |
| Shell | `bool` | `false` | 用于控制下载完成后是否执行对应房间的Shell命令 |

- DDTV WEBUI 配置文件变量<sup>5</sup>
<sup>5：变量只在 `第一次启动` 可用。</sup>
| 参数名 | 格式 | 默认值 | 说明 |
| ---- | ---- | ---- | ---- |
| WEBUI_Path | 路径 | `/DDTV/static` | WEBUI的文件夹路径 |
| PROXY_PASS | `http(s)://you.host:port` | `http://127.0.0.1:11419` | 需要反代的后端地址, apiUrl=false 时 WEBUI 从反代地址联系 WEB_Server |
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

- - 可使用更多的变量，见 ddtv_docker.env。


## CLI/WEB_Server 可用运行参数

```shell
docker run ... \
           --no-update # 不开启容器重启后更新 DDTV
           --verbose   # 脚本输出更多信息
```