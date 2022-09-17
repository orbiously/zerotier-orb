#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  printf "\nZeroTier CLI v.%s for macOS is already installed" "$(zerotier-cli -v)"
else
  echo "Installing ZeroTier CLI for macOS"
  curl "https://download.zerotier.com/dist/ZeroTier%20One.pkg" -o zerotier-one.pkg
  sudo installer -pkg zerotier-one.pkg -target
  printf "\nZeroTierCLI v.%s for macOS is now installed" "$(zerotier-cli -v)"
fi