#!/bin/bash

# Git仓库的URL
GIT_REPO_URL="https://github.com/fatedier/frp/releases/download/v0.60.0/frp_0.60.0_linux_amd64.tar.gz"
TAR_FILE_NAME="frp_0.60.0_linux_amd64.tar.gz"
UNPACK_DIR="frp_0.60.0_linux_amd64"
CLONE_DIR="/home/ubuntu/frp"


# 检查目标目录是否存在，如果不存在则创建
if [ ! -d "$CLONE_DIR" ]; then
  mkdir -p "$CLONE_DIR"
fi

# 克隆Git仓库到指定目录
git clone $GIT_REPO_URL $CLONE_DIR

# 进入克隆的目录
cd $CLONE_DIR

# 解压下载的文件
tar -zxvf $TAR_FILE_NAME
# 进入解压后的目录

cd $UNPACK_DIR

sudo touch /etc/systemd/system/frps.service
echo "
[Unit]
# 服务名称，可自定义
Description = frp server
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# 启动frps的命令，需修改为您的frps的安装路径
ExecStart = $CLONE_DIR/$UNPACK_DIR/frps -c $CLONE_DIR/$UNPACK_DIR/frps.toml

[Install]
WantedBy = multi-user.target
" >> /etc/systemd/system/frps.service

sudo systemctl daemon-reload
sudo systemctl start frps
sudo systemctl enable frps
