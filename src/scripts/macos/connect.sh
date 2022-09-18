#!/bin/bash

if (! sudo launchctl list | grep -q "com.zerotier.one"); then
    sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
    until sudo launchctl list | grep -q "com.zerotier.one"; do
     sleep 1;
    done
fi

echo "ZeroTier service started."

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

printf "\nAuthorizing member..."
if [ "$(curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_NET_ID}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}' -o /dev/null -s -w "%{http_code}" )" != "200" ]; then
  echo "Either the ZeroTier network ID or the ZeroTier API token is incorrect. Please check the respective values"
  exit 1
else
  printf "\nThis ZeroTier member is now authorized."
fi
    
sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowGlobal=true

printf "\nJoining ZeroTier network..."
sudo zerotier-cli join "${!PARAM_ZT_NET_ID}"

printf "\nContacting remote ZeroTier member"
until ping -c1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

printf "\nLink with ZeroTier member \"%s\" successfully established." "$PARAM_ZT_REMOTE_MBR"