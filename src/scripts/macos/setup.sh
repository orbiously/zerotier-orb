#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  echo "ZeroTier CLI v.$(zerotier-cli -v) for macOS is already installed"
else
  echo "Installing ZeroTier CLI for macOS"
  curl "https://download.zerotier.com/dist/ZeroTier%20One.pkg" -o zerotier-one.pkg
  sudo installer -pkg zerotier-one.pkg -target
  echo "ZeroTierCLI v.$(zerotier-cli -v) for macOS is now installed"
fi