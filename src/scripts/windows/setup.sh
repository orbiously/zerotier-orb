#!/bin/bash

if (/c/progra~2/ZeroTier/One/zerotier-cli.bat -v) > NUL 2>&1; then
  printf "\nZeroTier for Windows is already installed\n"
  echo "Installed version: v.$(/c/progra~2/ZeroTier/One/zerotier-cli.bat -v)"
else
  echo "Installing ZeroTier for Windows"
  curl "https://download.zerotier.com/dist/ZeroTier%20One.msi" -o zerotier-one.msi
  msiexec //i zerotier-one.msi //qn
  echo "ZeroTier v.$(/c/progra~2/ZeroTier/One/zerotier-cli.bat -v) for Windows is now installed"
fi