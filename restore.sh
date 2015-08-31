#!/bin/bash
#dirs=('bin' 'boot' 'etc' 'home' 'lib' 'lib64' 'root' 'sbin' 'usr' 'var')
dirs=('home')
suffix=$(date +%F)
src="/var/backups/vps/2015-08-31"
dest="root@192.168.56.101"

tar zxf "$src/etc.tar.gz" -C /tmp

scp -rp /tmp/etc/apt $dest:/etc/

# Install packages
packages="$(awk '/^\s*[^#]/' "$src/packages.list")"
cmd="apt-get install -fmy $packages"
echo $cmd > cmd

ssh $dest "apt-get update"
ssh $dest "apt-get -y dist-upgrade"
ssh $dest $cmd
exit
for dir in ${dirs[*]}
do
    echo "Processing $dir"
    cat "$src/$dir.tar.gz" | ssh -t $dest "tar xzf - -C /"
done
