#!/system/bin/sh

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
