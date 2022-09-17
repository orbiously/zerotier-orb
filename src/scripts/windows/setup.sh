#!/bin/bash

if ( /c/progra~2/ZeroTier/One/zerotier-cli.bat -v ) 2>/dev/null; then
  VERSION=$(/c/progra~2/ZeroTier/One/zerotier-cli.bat -v)
  echo "ZeroTier CLI v.$VERSION for Windows is already installed"
else
  echo "Installing ZeroTier CLI for Windows"
  curl "https://download.zerotier.com/dist/ZeroTier%20One.msi" -o zerotier-one.msi
  msiexec //i zerotier-one.msi //qn
  echo "ZeroTierCLI v.$(/c/progra~2/ZeroTier/One/zerotier-cli.bat -v) for Windows is now installed"
fi