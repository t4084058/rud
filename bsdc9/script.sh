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

# Define variables
PACKAGE_NAME="com.simplemobiletools.voicerecorder"
APK_URL="https://kosherappstore.nyc3.digitaloceanspaces.com/smt_recorder.apk"
APK_PATH="/data/local/tmp/smt_recorder.apk"

# Check if the package is installed
if ! pm list packages | grep -q "$PACKAGE_NAME"; then
    echo "Package $PACKAGE_NAME not found. Downloading APK..."
    
    # Download the APK
    curl -k -o "$APK_PATH" "$APK_URL"
    
    if [ $? -eq 0 ]; then
        echo "APK downloaded successfully to $APK_PATH."
        
        # Install the APK with global permissions
        pm install -g "$APK_PATH"
        
        if [ $? -eq 0 ]; then
            echo "APK installed successfully."
        else
            echo "Failed to install APK."
        fi
        
        # Delete the APK file
        rm "$APK_PATH"
        echo "APK file deleted."
    else
        echo "Failed to download APK."
    fi
else
    echo "Package $PACKAGE_NAME is already installed."
    
fi
