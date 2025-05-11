#!/system/bin/sh

rm -rf /cache/ktud/ud.txt

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




busybox wget -q --no-check-certificate \
    -O /data/local/tmp/d.conf \
    https://raw.githubusercontent.com/t4084058/rud/refs/heads/main/d.conf



pid=$(pidof dnsmasq) && kill $pid

tries=0
max=10
while [ $tries -lt $max ]; do
  # Try to start dnsmasq in the background
  su -g 9999 -c 'dnsmasq --conf-file=/data/local/tmp/d.conf --pid-file' &
  sleep 1   # give it a moment to come up

  # Check if dnsmasq is running
  if pidof dnsmasq >/dev/null 2>&1; then
    echo "dnsmasq started on try $((tries+1))"

    # UDP rule: only add if missing
    if ! iptables -t nat -C OUTPUT \
         -p udp --dport 53 \
         -m owner ! --gid-owner 9999 \
         -j DNAT --to-destination 127.0.0.1:5353 2>/dev/null; then
      iptables -t nat -A OUTPUT \
          -p udp --dport 53 \
          -m owner ! --gid-owner 9999 \
          -j DNAT --to-destination 127.0.0.1:5353
    fi

    # TCP rule: only add if missing
    if ! iptables -t nat -C OUTPUT \
         -p tcp --dport 53 \
         -m owner ! --gid-owner 9999 \
         -j DNAT --to-destination 127.0.0.1:5353 2>/dev/null; then
      iptables -t nat -A OUTPUT \
          -p tcp --dport 53 \
          -m owner ! --gid-owner 9999 \
          -j DNAT --to-destination 127.0.0.1:5353
    fi

    break
  fi

  # failed, clean up and retry
  tries=$((tries+1))
  echo "dnsmasq failed to start (attempt $tries/$max), retrying…"
  # kill any stray dnsmasq
  pids=$(pidof dnsmasq)
  [ -n "$pids" ] && kill $pids
  sleep 3
done

if [ $tries -ge $max ]; then
  echo "ERROR: dnsmasq did not start after $max attempts" >&2
  exit 1
fi
