#!/bin/bash
dirs=('bin' 'boot' 'etc' 'home' 'lib' 'lib64' 'root' 'sbin' 'usr' 'var')
suffix=$(date +%F)
dest="/media/peter/Data/vps/$suffix"
tmp="/media/peter/Data/tmp"
if [ ! -d $dest ]; then
    sudo mkdir -p $dest
fi
for dir in ${dirs[*]}
do
    echo "Processing $dir"
    ssh root@maslosoft.com "tar -czvf - /$dir 2> /var/log/sshbackup" > "$tmp/$dir.tar.gz"
    sudo mv "$tmp/$dir.tar.gz" $dest
done
ssh root@maslosoft.com "apt-mark showmanual" > "$tmp/packages.list"
sudo mv "$tmp/packages.list" $dest
