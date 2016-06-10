#!/bin/bash
dirs=('bin' 'boot' 'etc' 'home' 'lib' 'lib64' 'root' 'sbin' 'usr' 'var')
suffix=$(date +%F)
dest="/media/peter/Data/backups/vps/$suffix"
tmp="/media/peter/Data/tmp"
tmp=$(mktemp -d --tmpdir="$tmp")
user="peter"
pkg="$tmp/packages.list"
if [ ! -d $dest ]; then
    sudo mkdir -p $dest
	sudo chown "$user" "$dest"
fi
for dir in ${dirs[*]}
do
	src="$tmp/$dir.tar.bz2"
    echo "Processing $dir"
    ssh root@maslosoft.com "tar -cjvf - /$dir 2> /var/log/sshbackup" > "$src"
	sudo chown "$user" "$src"
    sudo mv "$src" "$dest"
done
ssh root@maslosoft.com "apt-mark showmanual" > "$pkg"
sudo chown "$user" "$pkg"
sudo mv "$pkg" "$dest"
