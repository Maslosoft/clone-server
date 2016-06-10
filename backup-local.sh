#!/bin/bash
dirs=('bin' 'boot' 'etc' 'home' 'lib' 'lib64' 'root' 'sbin' 'usr' 'var')
suffix=$(date +%F)
dest="/media/peter/Data/backups/local/$suffix"
tmp="/media/peter/Data/tmp"
if [ ! -d $dest ]; then
    sudo mkdir -p $dest
fi
for dir in ${dirs[*]}
do
	if [ ! -e "$dest/$dir.tar.gz" ]; then
		echo "Processing $dir"
		tar -czvf - "/$dir" 2> "$tmp/localbackup" > "$tmp/$dir.tar.gz"
		sudo mv "$tmp/$dir.tar.gz" "$dest"
	else
		echo "Skipping $dir"
	fi
done
apt-mark showmanual > "$tmp/packages.list"
sudo mv "$tmp/packages.list" $dest
