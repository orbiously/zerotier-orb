#!/bin/bash

if ( zerotier-cli -v ) 2>/dev/null; then
  echo "ZeroTier CLI v.$(zerotier-cli -v) for Linux is already installed"
else
  echo "Installing ZeroTier CLI for Linux"
  curl -s https://install.zerotier.com | sudo bash
  echo "ZeroTierCLI v.$(zerotier-cli -v) for Linux is now installed"
fi