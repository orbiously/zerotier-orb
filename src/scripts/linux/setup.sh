#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  printf "\nZeroTier CLI v.%s for Linux is already installed" "$(zerotier-cli -v)"
else
  echo "Installing ZeroTier CLI for Linux"
  curl -s https://install.zerotier.com | sudo bash
  echo "ZeroTierCLI v.$(zerotier-cli -v) for Linux is now installed"
fi