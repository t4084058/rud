#!/system/bin/sh

if [ ! -f /product/overlay/sidduroverlay.apk ]; then
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/sidduroverlay.apk https://raw.githubusercontent.com/t4084058/rud/main/ && mount -o rw,remount /product && cp /data/local/tmp/sidduroverlay.apk /product/overlay/ && echo "sidduroverlay" > /data/local/tmp/sidduroverlay.txt && mount -o ro,remount /product
fi

cmd overlay enable com.siddur.overlay
