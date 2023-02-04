# Docker-DDTV

该仓库仅用于测试。

分支关系：
```
master(测试)——→test(模块测试)
|   分离Docker文件夹为分支
↓   通过subtree提交
dev
↓   merge
docker
↑   submodule
CHKZL/DDTV/Docker
 ```
具体内容请查看[Github Docker目录](https://github.com/moomiji/docker-ddtv/tree/master/Docker)。

使用`ddtv/cli` `ddtv/deps` `ddtv/webserver`镜像请查看[DDTV Docker版安装教程](https://github.com/moomiji/docker-ddtv/blob/master/Doc/docs/install/Docker.md)。

将[DDTV Docker版安装教程](https://github.com/moomiji/docker-ddtv/blob/master/Doc/docs/install/Docker.md)里镜像名中的`chkzl`换为`moomiji`即可使用本仓库镜像。

可在[Github](https://github.com/moomiji/docker-ddtv)中Star[本项目](https://github.com/moomiji/docker-ddtv)更新本仓库镜像，在[Action](https://github.com/moomiji/Docker-DDTVLiveRec/actions/workflows/DDTVLiveRec_docker.yml)中查看更新进度。
