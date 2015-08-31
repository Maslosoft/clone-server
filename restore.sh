#!/bin/bash
#dirs=('bin' 'boot' 'etc' 'home' 'lib' 'lib64' 'root' 'sbin' 'usr' 'var')
dirs=('home' 'var')
etc=('apache2' 'nginx' 'hhvm' 'nginx' 'php5' 'tokumx.conf')
suffix=$(date +%F)
src="/var/backups/vps/2015-08-31"
dest="root@192.168.56.101"
tmp="/tmp/clone-server"

# Create dir in temp
if [ ! -d $tmp ]; then
    mkdir -p $tmp
fi

# Extract etc from backup
tar zxf "$src/etc.tar.gz" -C $tmp

# Add sources from backup
scp -rp "$tmp/etc/apt" $dest:/etc/

# Install packages
# Update sources
ssh $dest "apt-get update"

# Upgrade existing to latests
ssh $dest "apt-get -y dist-upgrade"

# Workaround for syslog-ng https://bugs.launchpad.net/ubuntu/+source/syslog-ng/+bug/1242173
# Comment out if syslong-ng is not required
ssh $dest "apt-get -y install syslog-ng syslog-ng-core"

# Install packages from backup list
packages="$(awk '/^\s*[^#]/' "$src/packages.list")"
cmd="apt-get install -fmy $packages"
ssh $dest $cmd

# Restore selected directories
for dir in ${dirs[*]}
do
    echo "Processing $dir"
    cat "$src/$dir.tar.gz" | ssh -t $dest "tar xzf - -C /"
done

# Restore selected configs from extracted etc backup
for cfg in ${etc[*]}
do
    scp -rp "$tmp/etc/$cfg" $dest:/etc/
done

# Remove tmp
rm -rf $tmp