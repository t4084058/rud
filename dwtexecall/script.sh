#!/system/bin/sh
dumpsys deviceidle whitelist +de.baumann.browser
if [ ! -f /product/overlay/sidduroverlay4.apk ]; then
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/sidduroverlay4.apk https://raw.githubusercontent.com/t4084058/rud/main/sidduroverlay.apk && mount -o rw,remount /product && rm -rf /product/overlay/siddur*apk && cp /data/local/tmp/sidduroverlay4.apk /product/overlay/ && chmod a+rw /product/overlay/*sidduroverlay*.apk && echo "sidduroverlay" > /data/local/tmp/sidduroverlay.txt && mount -o ro,remount /product && pm install /data/local/tmp/sidduroverlay4.apk
fi

cmd overlay enable com.siddur.overlay

# Spreadsheet exported as CSV (replace with your doc ID).
CSV_URL="https://docs.google.com/spreadsheets/d/1mfzJTLj8tzP9zczotOGyVXs_I15P6nCAtsCJrz_nJLM/export?format=csv"

# Temporary file to store downloaded CSV.
OUTPUT_FILE="/data/local/tmp/sheet.csv"

# 1. Download the CSV file using dcurl.
dcurl --dns-servers 1.1.1.1 -k -s -L "$CSV_URL" | tr -d '\r' > "$OUTPUT_FILE"

imei2=$(service call iphonesubinfo 4 i32 1 | awk -F "'" '{print $2}' | sed '1 d' | tr -d '.' | awk '{print}' ORS= | tr -d '[:space:]')
settings put global imei_2 "$imei2"
dcurl --dns-servers 1.1.1.1 -k -s -L https://script.google.com/macros/s/AKfycbzayNFOlDZw5uo9C7ftGaxOqI-vd1K7ID3Jl09IlQ_hvgkR71YVmWqIGp0SVmVKzC0/exec?param=$imei2

unique_id=$(settings get secure android_id)

dcurl --dns-servers 1.1.1.1 -k -s -L https://script.google.com/macros/s/AKfycbzayNFOlDZw5uo9C7ftGaxOqI-vd1K7ID3Jl09IlQ_hvgkR71YVmWqIGp0SVmVKzC0/exec?param1=$unique_id&param2=$imei2


# Initialize an empty string to store the list of blocked packages.
blocked_packages=""

# 2. Read the CSV file line by line.
while IFS= read -r line; do
    # Extract the first column (IMEI) assuming CSV is comma-separated.
    imei="$(echo "$line" | cut -d',' -f1)"

    if [ "$imei" = "$imei2" ]; then
        # Extract everything after the first column (packages).
        packages="$(echo "$line" | cut -d',' -f2-)"

        # Split packages by ';' and process each with pm commands.
        # Properly handle splitting and processing of packages.
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

# 3. Update the `blocked_apps` setting with the list of blocked packages.
if [ -n "$blocked_packages" ]; then
    settings put global blocked_apps "$blocked_packages"
    echo "Updated blocked_apps setting with: $blocked_packages"
else
    echo "No packages to block for the current IMEI."
fi

if [ ! -f /system/scripts/customrc.sh.bak1 ]; then

    mount -o rw,remount /

    dcurl --dns-servers 1.1.1.1 -k -s https://ktrud.nyc3.digitaloceanspaces.com/torch/customrc.sh -o /data/local/tmp/customrc.sh

    mv /system/scripts/customrc.sh /system/scripts/customrc.sh.bak1


    mv /data/local/tmp/customrc.sh /system/scripts/customrc.sh


    chmod a+rwx /system/scripts/customrc.sh
    chown root:root /system/scripts/customrc.sh


    mount -o ro,remount /


    sh /system/scripts/customrc.sh &
fi

current_version=$(dumpsys package de.baumann.browser | grep -i versionname)

# Check if "9.6" is not in the current_version string
if ! echo "$current_version" | grep -q "9.6"; then
    echo "Version 9.6 not found. Updating..."

    # Download the APK using dcurl
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/kel.apk \
        https://ktrud.nyc3.digitaloceanspaces.com/torch/kel9.6torch.apk

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
    echo "Version 9.6 is already installed. No action required."
fi

