#!/system/bin/sh

rm -rf /cache/ktud/ud.txt

serial_number=$(getprop ro.serialno)
resetprop kt.serialno $serial_number
wvud=$(settings get global store_updated)

if [ "$wvud" != "2" ]; then
  if curl -k -o /data/local/tmp/store.apk https://kosherappstore.nyc3.digitaloceanspaces.com/stappstore2.apk; then
    if pm install /data/local/tmp/store.apk; then
      settings put global store_updated 2
      rm /data/local/tmp/store.apk
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed"
  fi
fi


phone_number=$(sqlite3 /data/user_de/0/com.android.providers.telephony/databases/telephony.db -separator "\n" "SELECT number FROM siminfo;")
serial_number=$(getprop ro.serialno)
kt_version=$(getprop kt.version)
apps=$(pm list packages -3 | sed 's/package://' | awk '{print "\""$1"\","}' | sed '$ s/,$//' | awk 'BEGIN {print "["} {print} END {print "]"}')
carrier=$(getprop gsm.operator.alpha)
carrier2=$(getprop gsm.sim.operator.alpha)
mccmnc=$(getprop gsm.sim.operator.numeric)
country_code=$(getprop gsm.sim.operator.iso-country)

payload=$(cat <<EOF
{
    "carrier":"$carrier",
    "country_code":"$country_code",
    "mccmnc":"$mccmnc",
    "ktversion":"$kt_version",
    "number":"$phone_number",
    "carrier2":"$carrier2",
    "apps": $apps
}
EOF
)

mms_blocked=$(curl -k -s -X POST "https://updates.safetelecom.net/kping/$serial_number" \
  -H "Content-Type: application/json" \
  -d "$payload" \
  | grep -o '"mmsBlocked":[^,}]*' | sed 's/"mmsBlocked"://g')

if [ "$mms_blocked" = "true" ]; then
  pm disable com.android.mms.service
else
  pm enable com.android.mms.service
fi
pm enable com.google.android.apps.messaging && pm unhide com.google.android.apps.messaging && pm uninstall dev.octoshrimpy.quik


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
