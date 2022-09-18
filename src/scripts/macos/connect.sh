#!/bin/bash

if (! sudo launchctl list | grep "com.zerotier.one"); then
    sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
    until sudo launchctl list | grep "com.zerotier.one"; do
     sleep 1;
    done
fi

echo "ZeroTier service started."

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

echo "Authorizing member..."
curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_NET_ID}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}'

echo "This ZeroTier member is now authorized."
    
sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowGlobal=true

echo "Joining ZeroTier network..."
sudo zerotier-cli join "${!PARAM_ZT_NET_ID}"

echo "Contacting remote ZeroTier member"
until ping -c1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

echo "Link with ZeroTier member \"$PARAM_ZT_REMOTE_MBR\" successfully established."