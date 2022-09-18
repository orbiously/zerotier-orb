#!/bin/bash

if ( zerotier-cli -v ) > /dev/null 2>&1; then
  printf "\nZeroTier v.%s for macOS is already installed" "$(zerotier-cli -v)"
else
  echo "Installing ZeroTier for macOS"
  curl "https://download.zerotier.com/dist/ZeroTier%20One.pkg" -o zerotier-one.pkg
  sudo installer -pkg zerotier-one.pkg -target /
  printf "\nZeroTier v.%s for macOS is now installed" "$(zerotier-cli -v)"
fi

if (! sudo launchctl list | grep -q "com.zerotier.one"); then
  sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
fi

until sudo launchctl list | grep -q "com.zerotier.one"; do
  sleep 1;
done


echo "ZeroTier service started."