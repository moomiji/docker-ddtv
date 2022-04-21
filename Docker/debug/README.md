# 食用指南

该指南用于 ddtv 出现异常占用时，构建镜像并进行性能探测并记录给开发者分析。

## 构建与运行
```shell
git clone --depth 1 https://github.com/CHKZL/DDTV
DOTNET_VERSION=$(awk '/DOTNET_VERSION: /{print $2;exit}' FS="'" .github/workflows/DDTV_Docker_Release.yml)
cd ./DDTV/Docker/debug
# alpine
docker build --rm -t ddtv/debug:alpine --build-arg IMAGE_TAG=6.0-alpine .
docker run -it ${与 运行容器 相同的参数&配置文件} --rm --cap-add=SYS_ADMIN --cap-add=SYS_PTRACE --privileged --name ddtvdebug ddtv/debug:alpine
# debian
docker build --rm -t ddtv/debug:debian --build-arg IMAGE_TAG=6.0 .
docker run -it ${与 运行容器 相同的参数&配置文件} --rm --cap-add=SYS_ADMIN --cap-add=SYS_PTRACE --privileged --name ddtvdebug ddtv/debug:debian
```

## 性能探测与记录

- CPU 占用异常

当出现 CPU 占用异常时，运行以下命令 20~30 s，`Ctrl+C`停止记录。

```shell
# docker exec -it --privileged ddtvdebug /bin/bash
# perf record -p ${DDTV_WEB_Server进程号} -g
cd /DDTV
perf record -p $(ps -ef | grep -v "grep" | awk '/DDTV_WEB_Server/{print $1}') -g
```

## perf 记录转换为火焰图

```
. /etc/os-release
DDTV_WEB_Server_Version=$(cat DDTV_WEB_Server.deps.json | awk '/DDTV_WEB_Server\//{print $3}' FS='[/"]' | awk 'NR==1')
eval "perf script | FlameGraph/stackcollapse-perf.pl | FlameGraph/flamegraph.pl > DDTV.WEB_Server_Ver${DDTV_WEB_Server_Version}.in_${PRETTY_NAME}.svg"
```