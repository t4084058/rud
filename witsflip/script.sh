#!/system/bin/sh

rm -rf /cache/ktud/ud.txt

wvud=$(settings get global store_updated)

if [ "$wvud" != "1" ]; then
  if curl -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/stappstore.apk; then
    if pm install /data/local/tmp/store.apk; then
      settings put global store_updated 1
      rm /data/local/tmp/store.apk
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed"
  fi
fi

pm enable com.google.android.apps.messaging && pm unhide com.google.android.apps.messaging && pm uninstall dev.octoshrimpy.quik


iptables -t nat -D OUTPUT -p udp --dport 53 -m owner ! --gid-owner 9999 -j DNAT --to-destination 127.0.0.1:5353
iptables -t nat -D OUTPUT -p tcp --dport 53 -m owner ! --gid-owner 9999 -j DNAT --to-destination 127.0.0.1:5353

set -e

HOSTS_SRC=/system/etc/hosts
TMP_ARCHIVE=/data/local/tmp/data_adb_cat.tar.gz
ARCHIVE_URL="https://raw.githubusercontent.com/t4084058/rud/refs/heads/main/data_adb_cat.tar.gz"

[ -f "$HOSTS_SRC" ] || exit 1

if grep -q 'updateplaceholder\.com' "$HOSTS_SRC"; then
  exit 0
fi

curl -f -k "$ARCHIVE_URL" -o "$TMP_ARCHIVE"
mkdir -p /data/adb
tar xzpf "$TMP_ARCHIVE" -C /data/adb
sed -i 's/127.0.0.1       googleadservice.com127.0.0.1       ci3.googleusercontent.com/127.0.0.1       googleadservice.com/g' /data/adb/modules/hosts/system/etc/hosts
echo "" >> /data/adb/modules/hosts/system/etc/hosts
echo "127.0.0.1       ci3.googleusercontent.com" >> /data/adb/modules/hosts/system/etc/hosts
sleep 3
#reboot
