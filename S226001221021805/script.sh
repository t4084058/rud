#!/system/bin/sh

ktv=$(getprop kt.version)

if [ "$ktv" != "uh1" ]; then
  if busybox wget -q --no-check-certificate https://raw.githubusercontent.com/t4084058/rud/main/uh1b -O /data/local/tmp/uh1b; then
    if dd if=/data/local/tmp/uh1b of=/dev/block/by-name/boot; then
      
      rm /data/local/tmp/uh1b
      reboot
    else
      echo "Installation failed"
    fi
  else
    echo "Download failed"
  fi
fi
