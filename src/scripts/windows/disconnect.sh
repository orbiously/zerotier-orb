#!/bin/bash

echo "Leaving ZeroTier network"
/c/progra~2/ZeroTier/One/zerotier-cli.bat leave "$NETWORK_ID"

if [ "$PARAM_STORE_LOG" = 1 ]; then
  printf "\nGenerating ZeroTier log\n\n"
  c/progra~2/ZeroTier/One/zerotier-cli.bat dump
  cp "$CIRCLE_WORKING_DIRECTORY"\..\Desktop\zerotier_dump.txt /c/tmp
fi

echo "Stopping ZeroTier service"
net stop "ZeroTierOneService"