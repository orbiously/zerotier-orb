#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  printf "\nZeroTier v.%s for Linux is already installed" "$(zerotier-cli -v)"
else
  printf "\nInstalling ZeroTier for Linux"
  curl -s https://install.zerotier.com | sudo bash
  printf "\nZeroTierCLI v.%s for Linux is now installed" "$(zerotier-cli -v)"
fi

printf "\nStarting ZeroTier service..."
sudo systemctl start zerotier-one
until sudo systemctl status zerotier-one |grep -iq "running"; do
  sleep 1;
done

printf "\nZeroTier service started."