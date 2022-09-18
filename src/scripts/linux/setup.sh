#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  printf "\nZeroTier v.%s for Linux is already installed" "$(zerotier-cli -v)"
else
  echo "Installing ZeroTier for Linux"
  curl -s https://install.zerotier.com | sudo bash
  printf "\nZeroTierCLI v.%s for Linux is now installed" "$(zerotier-cli -v)"
fi