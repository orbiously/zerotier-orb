#!/bin/bash

echo "Leaving ZeroTier network"
/c/progra~2/ZeroTier/One/zerotier-cli.bat leave "$NETWORK_ID"

if [ "$PARAM_STORE_LOG" = 1 ]; then
  printf "\nGenerating ZeroTier log\n\n"
  cd /c/tmp && /c/progra~2/ZeroTier/One/zerotier-cli.bat dump
fi

echo "Stopping ZeroTier service"
sudo systemctl stop zerotier-one