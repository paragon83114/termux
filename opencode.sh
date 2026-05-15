#!/data/data/com.termux/files/usr/bin/bash

proot-distro login --shared-tmp --work-dir "$PWD" debian -- opencode "$@" 2>/dev/null
