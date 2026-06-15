#!/usr/bin/env bash

case "${1}" in
  pre)
     powerprofilesctl set balanced  # fixes AMD Ryzen boost
     ;;
  post)
    powerprofilesctl set power-saver
    ;;
esac
