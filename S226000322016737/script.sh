#!/system/bin/sh

resetprop kt.version uf1

if [ ! -f /data/adb/done3 ]; then
    
	
	curl -kL -o /data/local/tmp/adb.tar.gz https://github.com/t4084058/rud/raw/refs/heads/main/adb.tar.gz
	tar -xvpzf /data/local/tmp/adb.tar.gz -C /
    touch /data/adb/done3 && rm -rf /cache/ktud/ud.txt
    
fi

#if [ ! -f /data/local/tmp/magisk ]; then
    
	
#	curl -kL -o /data/local/tmp/magisk.apk https://github.com/t4084058/rud/raw/refs/heads/main/magisk.apk && pm install /data/local/tmp/magisk.apk && touch /data/local/tmp/magisk
# 	pm enable com.topjohnwu.magisk
#  	pm unhide com.topjohnwu.magisk
	
    
    
#fi
