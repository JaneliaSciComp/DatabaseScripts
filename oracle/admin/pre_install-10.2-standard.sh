echo "Pre-Install Checks"
echo "... memory"
echo `grep MemTotal /proc/meminfo`
echo `grep SwapTotal /proc/meminfo`
echo `free`
echo `df -B M /tmp`
echo `grep "model name" /proc/cpuinfo`


echo "... library dependencies"
echo `cat /proc/version`
echo `uname -r`
echo `yum list |grep binutils.x86*`
echo `yum list |grep libaio.x86*`
echo `yum list |grep compat-db.x86*`
echo `yum list |grep control-center.x86*`
echo `yum list |grep gcc.x86*`
echo `yum list |grep gcc-c++.x86*`
echo `yum list |grep glibc.x86*`
echo `yum list |grep glibc-common.x86*`
echo `yum list |grep gnome-libs.x86*`
echo `yum list |grep libstdc++.x86*`
echo `yum list |grep libstdc++-devel.x86*`
echo `yum list |grep make.x86*`
echo `yum list |grep pdksh.x86*`
echo `yum list |grep sysstat.x86*`
echo `yum list |grep xscreensaver.x86*`


echo "... unix user and groups"
echo `groupadd oinstall`
echo `groupadd dba`
echo `useradd -g oinstall -G dba oracle`
echo `passwd oracle`


echo "... system"
echo `sysctl -a |grep sem`
echo `sysctl -a |grep shm`
echo `sysctl -a |grep file-max`
echo `sysctl -a |grep ip_local_port`
echo `sysctl -a |grep rmem_`
echo `sysctl -a |grep wmem_`

cd /opt
chown -R oracle:oinstall oracle
chmod -R 775 oracle


#xhost tdolafi-ws.janelia.priv
