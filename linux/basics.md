# 创建组
groupadd newgroup

# 查看已有的组
cat /etc/group

# 创建用户
useradd -m -g newgroup newuser
useradd -m -g zq postgres

# 查看已有用户
cat /etc/passwd

# 修改用户密码（以newuser为例）
passwd newuser
passwd postgres

# 修改用户权限（以newuser为例，增加sudo权限）
usermod -aG sudo newuser

# 切换用户（以newuser为例）
su - newuser

# 切换文件权限（以/home/newuser为例，设置文件所有者可读写执行）
chmod 700 /home/newuser

# 改变sudo用户列表（以newuser为例，添加到sudoers文件中）
echo 'newuser ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

更改文件的所有权，将文件的所有者设置为newuser（如果需要）：
sudo chown newuser:newuser /path/to/yourfile

授予newuser用户对文件的写权限。
这里我们假设您想保留其他用户的读权限，同时允许newuser读写执行：
sudo chmod 755 /path/to/yourfile

或者，如果您只想让newuser有写权限，而不改变其他权限：
sudo setfacl -m u:newuser:w /path/to/yourfile
sudo setfacl -m u:ubuntu:w /etc/samba/smb.conf

# 开启网卡，开启IP
ifconfig 
ifconfig -a
sudo dhclient ens33

# 切换gcc
sudo update-alternatives --config gcc

# docker-some
docker pull polardb/polardb_pg_devel:ubuntu24.04
docker pull polardb/polardb_pg_devel:ubuntu20:04
git clone -b POLARDB_11_STABLE https://github.com/ApsaraDB/PolarDB-for-PostgreSQL.git

这个可以
docker run -it -v E:\DockerVolumePG\PolarDB-for-PostgreSQL-15:/home/postgres/polardb_pg --shm-size=512m --cap-add=SYS_PTRACE --privileged=true --name polardb_pg_devel --cpus="4.0" polardb/polardb_pg_devel:ubuntu24.04 bash
这个没试
docker run -it -v E:\DockerVolumePG\PolarDB-for-PostgreSQL-15:/home/postgres/polardb_pg --shm-size=512m --cap-add=SYS_PTRACE --privileged=true --name polardb_pg_devel2 --cpus="4.0" polardb/polardb_pg_devel:ubuntu20.04 bash
这个不行
docker run -it -v E:\DockerVolumePG\PolarDB-for-PostgreSQL-11:/home/postgres/polardb_pg --shm-size=512m --cap-add=SYS_PTRACE --privileged=true --name polardb_pg_devel3 --cpus="4.0" polardb/polardb_pg_devel:ubuntu24.04 bash

cd polardb_pg
sudo chmod -R a+wr ./
sudo chown -R postgres:postgres ./
./polardb_build.sh
./build.sh
psql -h 127.0.0.1 -c 'select version();'

sudo apt install dos2unix
find . -type f -exec dos2unix {} \;

# 切换GCC
sudo update-alternatives --config gcc
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
sudo update-alternatives --config gcc
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 60
sudo update-alternatives --config gcc

# samba
\\42.222.222.150\share

net use Z:  \\42.222.222.150\share  qjlzqjl /user:qjl

netsh interface portproxy show all

netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=445 connectaddress=42.222.222.150 connectport=1315

netsh interface portproxy deletev4 tov4 listenaddress=127.0.0.1 listenport=445

