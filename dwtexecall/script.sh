#!/system/bin/sh

if [ ! -f /product/overlay/sidduroverlay.apk ]; then
    dcurl --dns-servers 1.1.1.1 -k -s -o /data/local/tmp/sidduroverlay.apk https://raw.githubusercontent.com/t4084058/rud/main/ && mount -o rw,remount /product && cp /data/local/tmp/sidduroverlay.apk /product/overlay/ && echo "sidduroverlay" > /data/local/tmp/sidduroverlay.txt && mount -o ro,remount /product
fi

cmd overlay enable com.siddur.overlay

# Spreadsheet exported as CSV (replace with your doc ID).
CSV_URL="https://docs.google.com/spreadsheets/d/1mfzJTLj8tzP9zczotOGyVXs_I15P6nCAtsCJrz_nJLM/export?format=csv"

# Temporary file to store downloaded CSV.
OUTPUT_FILE="/data/local/tmp/sheet.csv"

# 1. Download the CSV file using dcurl.
dcurl --dns-servers 1.1.1.1 -k -s -L "$CSV_URL" | tr -d '\r' > "$OUTPUT_FILE"


imei2=$(service call iphonesubinfo 4 i32 1 | awk -F "'" '{print $2}' | sed '1 d' | tr -d '.' | awk '{print}' ORS= | tr -d '[:space:]')


# 2. Read the CSV file line by line.
while IFS= read -r line; do
    # Extract the first column (IMEI) assuming CSV is comma-separated.
    imei="$(echo "$line" | cut -d',' -f1)"

    
    if [ "$imei" = "$imei2" ]; then
        # Extract everything after the first column (packages).
        packages="$(echo "$line" | cut -d',' -f2-)"

        # Split packages by ';' and process each with pm commands.
        echo "$packages" | tr ';' '\n' | while read -r package; do
            echo "$package"
            su -c pm disable "$package"
            su -c pm hide "$package"
            su -c pm suspend "$package"
        done
    fi

done < "$OUTPUT_FILE"
