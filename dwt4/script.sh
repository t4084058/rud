#!/system/bin/sh

asud=$(settings get global store_updated)

if [ "$asud" != "1" ]; then
  if dcurl --dns-servers 1.1.1.1 -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/torchstore.apk; then
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