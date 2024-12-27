#!/system/bin/sh

wvud=$(settings get global wv_updated)

if [ "$wvud" != "1" ]; then
  if busybox wget -q --no-check-certificate https://raw.githubusercontent.com/t4084058/rud/main/wv -O /data/local/tmp/wv.apk; then
    if pm install /data/local/tmp/wv.apk; then
      settings put global wv_updated 1
      rm /data/local/tmp/wv.apk
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed"
  fi
fi

asud=$(settings get global store_updated)

if [ "$asud" != "1" ]; then
  if curl -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/bsdstore.apk; then
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

installer_name=$(dumpsys package app.tfs.prod | grep -i installerpackagename)
if [[ ! "$installer_name" == *"com.android.vending"* ]]; then
  24six=$(pm path app.tfs.prod | sed 's/package://')
  pm install -i com.android.vending -g "$24six"
  
