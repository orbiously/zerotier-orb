#!/bin/bash

echo "Leaving ZeroTier network"
sudo zerotier-cli leave "$NETWORK_ID"

if [ "$PARAM_STORE_DUMP" = 1 ]; then
  printf "\nGenerating ZeroTier log\n\n"
  sudo zerotier-cli dump
  cp /Users/distiller/Desktop/zerotier_dump.txt /tmp
fi

echo "Stopping ZeroTier service"
sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist