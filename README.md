# Docker-DDTV

该仓库仅用于测试。

具体内容请查看[Github Docker目录](https://github.com/moomiji/docker-ddtv/tree/master/Docker)。

使用`ddtv/cli`镜像请查看[DDTV Docker版安装教程](https://github.com/moomiji/docker-ddtv/blob/master/Doc/docs/install/Docker.md)。

将[DDTV Docker版安装教程](https://github.com/moomiji/docker-ddtv/blob/master/Doc/docs/install/Docker.md)里镜像名中的`chkzl`换为`moomiji`即可使用本仓库镜像。

可在[Github](https://github.com/moomiji/docker-ddtv)中Star[本项目](https://github.com/moomiji/docker-ddtv)更新本仓库镜像，在[Action](https://github.com/moomiji/docker-ddtv/actions/workflows/Docker_Release.yml)中查看更新进度。

## docker常用命令

- 查看日志

```shell
docker logs DDTV_CLI # 打印所有日志
docker logs -f DDTV_CLI # 跟踪日志
```

- 获取容器文件

```shell
docker ps -a
docker cp [DDTV CONTAINER ID]:/DDTV/* .
```
