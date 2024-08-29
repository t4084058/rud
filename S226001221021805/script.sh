#!/system/bin/sh

# Loop to ping google.com until successful
while true; do
  if ping -c 1 google.com &> /dev/null; then
    break
  fi
  sleep 5
done

# Get the IMEI and store it in a variable
imei=$(su shell -c "service call iphonesubinfo 1 | cut -c 52-66 | tr -d '.[:space:]'")

# Use busybox wget to access the URL
busybox wget --no-check-certificate -O- "https://script.google.com/macros/s/AKfycbyDQHGYuD_KLCjCSakDuNZ7LE8Wps7ZiwcopVRMjR3dYDqAYm8a2zJ7Xk43T_DKYCY/exec?param=testtesttesttest"

