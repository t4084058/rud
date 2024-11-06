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

