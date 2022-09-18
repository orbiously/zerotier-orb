#!/bin/bash

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

printf "\nAuthorizing member..."
if [ "$(curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_NET_ID}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}' -o /dev/null -s -w "%{http_code}" )" != "200" ]; then
  printf "\n\nCould not authorize member."
  printf "\nEither the ZeroTier network ID or the ZeroTier API token is incorrect. Please check the respective values."
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