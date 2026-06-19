#!/usr/bin/env bash

case "${1}" in
  pre)
     powerprofilesctl set balanced  # fixes AMD Ryzen boost bug on wakeup
     rfkill block all  # prevents exploits and battery drain
     ;;
  post)
    powerprofilesctl set power-saver
    rfkill unblock wifi
    ;;
esac
