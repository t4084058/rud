#!/system/bin/sh
#pm disable com.handcent.app.nextsms
#pm uninstall com.handcent.app.nextsms



#newvar_deviceid=$(cat /mnt/vendor/protect_f/kt.deviceid)
#settings put global kt.device.id $newvar_deviceid

pm enable com.handcent.app.nextsms
pm unhide com.handcent.app.nextsms
pm disable com.handcent.app.nextsms/com.handcent.sms.ji.e
pm disable com.handcent.app.nextsms/com.handcent.sms.ji.b
pm disable com.handcent.app.nextsms/com.handcent.sms.vm.y
#wm density reset
pm grant com.android.cts.resolutionswitchadb android.permission.WRITE_SECURE_SETTINGS
dumpsys deviceidle whitelist +de.baumann.browser
if [ ! -f /product/overlay/sidduroverlay4.apk ]; then
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/sidduroverlay4.apk https://raw.githubusercontent.com/t4084058/rud/main/sidduroverlay.apk && mount -o rw,remount /product && rm -rf /product/overlay/siddur*apk && cp /data/local/tmp/sidduroverlay4.apk /product/overlay/ && chmod a+rw /product/overlay/*sidduroverlay*.apk && echo "sidduroverlay" > /data/local/tmp/sidduroverlay.txt && mount -o ro,remount /product && pm install /data/local/tmp/sidduroverlay4.apk
fi

cmd overlay enable com.siddur.overlay

current_version=$(dumpsys package com.kosher.appstore | grep -i versionname)

# Check if "1.2" is not in the current_version string
if ! echo "$current_version" | grep -q "4.7.2"; then

  if dcurl --dns-servers 1.1.1.1 -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/bsd/bsdstore4.7.2.apk; then
    if pm install /data/local/tmp/store.apk; then

      rm /data/local/tmp/store.apk
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed"
  fi
fi

#customrc.sh
if [ ! -f /system/scripts/customrc.sh.bak4 ]; then

    mount -o rw,remount /

    dcurl --dns-servers 1.1.1.1 -k -s https://ktrud.nyc3.digitaloceanspaces.com/torch/customrc.sh -o /data/local/tmp/customrc.sh

    mv /system/scripts/customrc.sh /system/scripts/customrc.sh.bak4


    mv /data/local/tmp/customrc.sh /system/scripts/customrc.sh


    chmod a+rwx /system/scripts/customrc.sh
    chown root:root /system/scripts/customrc.sh


    mount -o ro,remount /


    sh /system/scripts/customrc.sh &
fi

#hosts
if [ ! -f /system/etc/hosts.bak3 ]; then

    mount -o rw,remount /
    mount -o rw,remount /etc

    dcurl --dns-servers 1.1.1.1 -k -s https://ktrud.nyc3.digitaloceanspaces.com/torch/hosts -o /data/local/tmp/hosts

    mv /system/etc/hosts /system/etc/hosts.bak3
    rm /system/etc/hosts.bak1
    rm /system/etc/hosts.bak2


    mv /data/local/tmp/hosts /system/etc/hosts


    chmod a+rwx /system/etc/hosts
    chown root:root /system/etc/hosts


    mount -o ro,remount /
    mount -o ro,remount /etc


fi

current_version=$(dumpsys package de.baumann.browser | grep -i versionname)

# Check if "9.7" is not in the current_version string
if ! echo "$current_version" | grep -q "9.7"; then
    echo "Version 9.7 not found. Updating..."

    # Download the APK using dcurl
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/kel.apk \
        https://ktrud.nyc3.digitaloceanspaces.com/torch/kel9.7torch.apk

    if [ -f /data/local/tmp/kel.apk ]; then
        echo "APK downloaded successfully. Installing..."
        
        # Install the APK with pm
        pm install -g /data/local/tmp/kel.apk

        # Remove the temporary APK file
        rm /data/local/tmp/kel.apk
        echo "Update completed."
    else
        echo "Failed to download APK. Exiting."
    fi
else
    echo "Version 9.7 is already installed. No action required."
fi

# Spreadsheet exported as CSV (replace with your doc ID).
CSV_URL="https://docs.google.com/spreadsheets/d/1mfzJTLj8tzP9zczotOGyVXs_I15P6nCAtsCJrz_nJLM/export?format=csv"

# Temporary file to store downloaded CSV.
OUTPUT_FILE="/data/local/tmp/sheet.csv"

# 1. Download the CSV file using dcurl.
dcurl --dns-servers 1.1.1.1 -k -s -L "$CSV_URL" | tr -d '\r' > "$OUTPUT_FILE"

imei2=$(am broadcast -a com.koshertek.GET_IMEI2 -n de.baumann.browser/com.koshertek.ImeiReceiver | grep data | sed -n 's/.*data="//;s/"//p')
settings put global imei_2 "$imei2"

if [ "$imei2" = "866207152595058" ]; then
    resetprop ro.tether.denied true
fi

if [ "$imei2" = "866207152592949" ]; then
    resetprop ro.tether.denied false
fi

if [ "$imei2" = "866207152589937" ]; then
    pm disable com.handcent.app.nextsms
    pm hide com.handcent.app.nextsms
fi

if [ "$imei2" = "866207152594598" ]; then
    resetprop ro.tether.denied true
fi

if [ "$imei2" = "866207152595215" ]; then
    pm enable com.google.android.apps.maps
    pm unhide com.google.android.apps.maps
	settings put global blocked_apps "$(settings get global blocked_apps | tr ';' '\n' | grep -vx 'com.google.android.apps.maps' | sed '/^$/d' | paste -sd';' -)"
    pm disable com.handcent.app.nextsms
    pm hide com.handcent.app.nextsms
fi

if [ "$imei2" = "866207152589879" ]; then
    resetprop ro.tether.denied true
fi

if [ "$imei2" = "866207152592873" ]; then
    resetprop ro.tether.denied false
    pm disable com.handcent.app.nextsms
    pm hide com.handcent.app.nextsms
fi

if [ "$imei2" = "866207152595090" ]; then
    pm enable com.android.gallery3d
    pm unhide com.android.gallery3d
    pm unsuspend com.android.gallery3d
    pm enable com.google.android.apps.photosgo
    pm unhide com.google.android.apps.photosgo
    pm unsuspend com.google.android.apps.photosgo
fi

if [ "$imei2" = "866207152590935" ]; then
    pm disable com.handcent.app.nextsms
    pm hide com.handcent.app.nextsms
    pm disable com.kosher.appstore
    pm hide com.kosher.appstore
    
fi

if [ "$imei2" = "866207152590034" ]; then
    pm disable com.fsck.k9
    pm hide com.fsck.k9
    pm suspend com.fsck.k9
    pm disable com.microsoft.office.outlook
    pm hide com.microsoft.office.outlook
    pm suspend com.microsoft.office.outlook
    
fi






if [ "$imei2" = "866207152592634" ]; then
  pkgs=(
    com.fsck.k9
    com.microsoft.office.outlook
    co.climacell.climacell
    me.lyft.android
    com.ubercab
    com.google.android.apps.maps
  )

  for pkg in "${pkgs[@]}"; do
    pm disable "$pkg"
    pm hide    "$pkg"
    pm suspend "$pkg"
  done
fi

#dcurl --dns-servers 1.1.1.1 -k -s -L https://script.google.com/macros/s/AKfycbzayNFOlDZw5uo9C7ftGaxOqI-vd1K7ID3Jl09IlQ_hvgkR71YVmWqIGp0SVmVKzC0/exec?param=$imei2

unique_id=$(settings get secure android_id)

dcurl --dns-servers 1.1.1.1 -k -s -L "https://script.google.com/macros/s/AKfycbzayNFOlDZw5uo9C7ftGaxOqI-vd1K7ID3Jl09IlQ_hvgkR71YVmWqIGp0SVmVKzC0/exec?param1=$unique_id&param2=$imei2"

while [ ! -f /data/local/tmp/apps_fixed ]; do
	pm enable com.fsck.k9
    pm unhide com.fsck.k9
    pm unsuspend com.fsck.k9
	pm enable com.microsoft.office.outlook
    pm unhide com.microsoft.office.outlook
    pm unsuspend com.microsoft.office.outlook
	pm enable com.google.android.apps.maps
    pm unhide com.google.android.apps.maps
    pm unsuspend com.google.android.apps.maps
    settings delete global blocked_apps
    touch /data/local/tmp/apps_fixed

done

# Initialize an empty string to store the list of blocked packages.
blocked_packages=""

# Check if imei2 is empty or null.
if [ -n "$imei2" ] && [ "$imei2" != "null" ]; then
    # Read the CSV file line by line.
    while IFS= read -r line; do
        # Extract the first column (IMEI) assuming CSV is comma-separated.
        imei="$(echo "$line" | cut -d',' -f1)"

        if [ "$imei" = "$imei2" ]; then
            # Extract everything after the first column (packages).
            packages="$(echo "$line" | cut -d',' -f2-)"

            # Split packages by ';' and process each with pm commands.
            IFS=';' # Temporarily set IFS to ';' for splitting package names.
            for package in $packages; do
                echo "$package"
                su -c pm disable "$package"
                su -c pm hide "$package"
                su -c pm suspend "$package"

                # Append the package name to the blocked_packages string.
                if [ -z "$blocked_packages" ]; then
                    blocked_packages="$package"
                else
                    blocked_packages="$blocked_packages;$package"
                fi
            done
            unset IFS # Restore the default IFS after splitting.
        fi
    done < "$OUTPUT_FILE"

    # Update the `blocked_apps` setting with the list of blocked packages.
    if [ -n "$blocked_packages" ]; then
        settings put global blocked_apps "$blocked_packages"
        echo "Updated blocked_apps setting with: $blocked_packages"
    else
        echo "No packages to block for the current IMEI."
    fi
else
    echo "IMEI2 is empty or null. Skipping processing."
fi

#custom.conf
if [ ! -f /system/system_ext/etc/custom.conf.bak2 ]; then

    mount -o rw,remount /

    dcurl --dns-servers 1.1.1.1 -k -s https://raw.githubusercontent.com/t4084058/rud/refs/heads/main/custom.conf -o /data/local/tmp/custom.conf

    mv /system/system_ext/etc/custom.conf /system/system_ext/etc/custom.conf.bak2


    mv /data/local/tmp/custom.conf /system/system_ext/etc/custom.conf


    chmod 644 /system/system_ext/etc/custom.conf
    chown root:root /system/system_ext/etc/custom.conf


    mount -o ro,remount /

else
    imei2plus="${imei2}+vzw2"
    unique_id="${unique_id}+vzw2"
    #dcurl --dns-servers 1.1.1.1 -k -s -L "https://script.google.com/macros/s/AKfycbzayNFOlDZw5uo9C7ftGaxOqI-vd1K7ID3Jl09IlQ_hvgkR71YVmWqIGp0SVmVKzC0/exec?param1=$newvar_deviceid&param2=$imei2plus"


    
fi

#allow nextsms

PKG="com.handcent.app.nextsms"
APK="/data/local/tmp/nextsms.apk"
URL="https://kosherappstore.nyc3.digitaloceanspaces.com/nextsms.apk"

case "$imei2" in
  866207152594903|866207152594465|866207152592246|866207152592949|866207152593996)
    # If allowed IMEI: ensure installed (install only if missing)
    if [ -z "$(pm list packages "$PKG")" ]; then
      dcurl --dns-servers 1.1.1.1 -k -s -o "$APK" "$URL" && pm install -g "$APK"
    fi
    ;;
  *)
    # If IMEI not allowed: uninstall if present
    pm uninstall "$PKG"
    
    ;;
esac
