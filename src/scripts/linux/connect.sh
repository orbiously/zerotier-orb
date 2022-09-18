#!/bin/bash

if (! sudo systemctl status zerotier-one |grep -i "running"); then
  echo "Starting ZeroTier service..."
  sudo systemctl start zerotier-one
  until sudo systemctl status zerotier-one |grep -i "running"; do
    sleep 1;
  done
fi

echo "ZeroTier service started."

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

echo "Authorizing member..."
if (! curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_NET_ID}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}'); then
  echo "Either the ZeroTier network ID or the ZeroTier API token is incorrect. Please check the respective values"
  exit 1
else
  echo "This ZeroTier member is now authorized."
fi
    
sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowGlobal=true

echo "Joining ZeroTier network..."
sudo zerotier-cli join "${!PARAM_ZT_NET_ID}"

echo "Contacting remote ZeroTier member"
until ping -c1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

echo "Link with ZeroTier member \"$PARAM_ZT_REMOTE_MBR\" successfully established."