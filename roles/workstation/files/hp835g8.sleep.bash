#!/usr/bin/env bash

case "${1}" in
  pre)
     powerprofilesctl set balanced  # fixes AMD Ryzen boost
     rfkill block wifi  # fixes WiFi stability
     ;;
  post)
    powerprofilesctl set power-saver
    rfkill unblock wifi
    ;;
esac
