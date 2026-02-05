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
    echo "Download failed "
  fi
fi

MARKER_FILE="/mnt/vendor/persist/kt.registered3"
DEVICEID_FILE="/mnt/vendor/persist/kt.deviceid3"
MAX_ATTEMPTS=10

echo "=========================================="
echo "Device Registration Script Starting"
echo "=========================================="

# Check if device is already registered
if [ ! -f "$MARKER_FILE" ]; then
    echo "[INFO] Marker file not found. Device needs registration."

    registered=0
    attempt=1
    while [ "$registered" -eq 0 ] && [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
        echo "[INFO] Starting registration attempt $attempt of $MAX_ATTEMPTS..."

        # Generate device ID if it doesn't exist
        if [ ! -f "$DEVICEID_FILE" ]; then
            echo "[INFO] Device ID file not found. Generating new device ID..."
            tr -dc 'A-Z0-9' < /dev/urandom | head -c 12 > "$DEVICEID_FILE"
            echo "[INFO] New device ID generated and saved to $DEVICEID_FILE"
        else
            echo "[INFO] Existing device ID file found."
        fi

        # Read the device ID
        newvar_deviceid=$(cat "$DEVICEID_FILE")
        echo "[INFO] Device ID: $newvar_deviceid"

        # Attempt registration with server
        echo "[INFO] Sending registration request to server..."
        response=$(curl -k -s -X POST https://koshertek.org/registrations/v2/ \
            -H "Content-Type: application/json" \
            -d "{\"unique_id\": \"$newvar_deviceid\", \"device_type\": \"BSD_CAT\"}")

        echo "[INFO] Server response: $response"

        # Check if registration was successful (handle JSON response)
        if echo "$response" | grep -q '"success": true'; then
            echo "[SUCCESS] Registration successful!"
            echo "[INFO] Creating marker file: $MARKER_FILE"
            touch "$MARKER_FILE"

            echo "[INFO] Storing device ID in system settings..."
            settings put global kt.device.id "$newvar_deviceid"

            registered=1
            echo "[INFO] Registration process complete."
        else
            echo "[WARNING] Registration failed. Server response: $response"
            echo "[INFO] Removing device ID file to generate new ID on retry..."
            rm -f "$DEVICEID_FILE"

            attempt=$((attempt + 1))
            if [ "$attempt" -le "$MAX_ATTEMPTS" ]; then
                echo "[INFO] Waiting 5 seconds before retry..."
                sleep 5
            fi
        fi
    done

    if [ "$registered" -eq 0 ]; then
        echo "[ERROR] Registration failed after $MAX_ATTEMPTS attempts. Giving up."
    fi
else
    echo "[INFO] Device already registered. Marker file exists at $MARKER_FILE"
    echo "[INFO] Skipping registration."
fi

echo "=========================================="
echo "Device Registration Script Finished"
echo "=========================================="

newvar_deviceid=$(cat /mnt/vendor/persist/kt.deviceid3)
settings put global kt.device.id $newvar_deviceid

current_version=$(dumpsys package com.kosher.appstore | grep -i versionname)

# Check if "1.2" is not in the current_version string
if ! echo "$current_version" | grep -q "4.7.4"; then

  if curl -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.cdn.digitaloceanspaces.com/torch_store_4.7.4.apk; then
    if pm install /data/local/tmp/store.apk; then

      rm /data/local/tmp/store.apk
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed "
  fi
fi


installer_name=$(dumpsys package app.tfs.prod | grep -i installerpackagename)
if [[ ! "$installer_name" == *"com.android.vending"* ]]; then
  tfsix=$(pm path app.tfs.prod | sed 's/package://')
  pm install -i com.android.vending -g "$tfsix"
fi
  
#Define variables
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
rm -rf /cache/ktud/ud.txt

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

