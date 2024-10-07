#!/system/bin/sh

VALUE=$(settings get global scripts_erased)


if [ "$VALUE" -ne 1 ]; then
    for file in /data/local/tmp/*.sh; do
        rm -rf "$file"
    done
    settings put global scripts_erased 1
fi


