#!/bin/bash

echo "Leaving ZeroTier network"
sudo zerotier-cli leave "$NETWORK_ID"

if [ "$PARAM_STORE_LOG" = 1 ]; then
  printf "\nGenerating ZeroTier log\n\n"
  cd /tmp && sudo zerotier-cli dump
fi

echo "Stopping ZeroTier service"
sudo systemctl stop zerotier-one