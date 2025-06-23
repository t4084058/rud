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

current_version=$(dumpsys package com.kosher.appstore | grep -i versionname)

# Check if "1.2" is not in the current_version string
if ! echo "$current_version" | grep -q "4.7.2"; then

  if curl -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/bsd/bsdstore4.7.2.apk; then
    if pm install /data/local/tmp/store.apk; then

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
  tfsix=$(pm path app.tfs.prod | sed 's/package://')
  pm install -i com.android.vending -g "$tfsix"
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

PACKAGE_NAME="app.tfs.prod"

# Check if the package is installed
if ! pm list packages | grep -q "$PACKAGE_NAME"; then
    echo 1 > /cache/ktud/ud.txt
fi
    
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
reboot
