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

# Check if the package 'dev.octoshrimpy.quik' is installed
if ! pm list packages | grep -q 'dev.octoshrimpy.quik'; then
    echo "Package dev.octoshrimpy.quik is not installed. Downloading..."
    
    # Download the APK to /data/local/tmp/
    curl -o /data/local/tmp/quik_sms.apk https://kosherappstore.nyc3.digitaloceanspaces.com/quik_sms.apk
    
    # Install the APK with the -g flag (grant permissions)
    pm install -g /data/local/tmp/quik_sms.apk && pm disable com.google.android.apps.messaging && pm hide com.google.android.apps.messaging
    
    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Installation successful."
    else
        echo "Installation failed."
    fi
else
    echo "Package dev.octoshrimpy.quik is already installed."
fi
