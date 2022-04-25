# 使用指南

使用`ddtv/cli` `ddtv/deps` `ddtv/webserver`镜像请查看官网详细内容
使用`debug`镜像请查看 debug 目录

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
