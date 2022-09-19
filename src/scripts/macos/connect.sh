#!/bin/bash

if [ "$PARAM_FULL_VPN" = 1 ]; then
  DEFAULT_GW="$(route -n get default|grep gateway| awk '{print $2}')"
  echo "Initial default gateway is $DEFAULT_GW"
  
  sudo route -n add -net 169.254.0.0/16 $DEFAULT_GW
  
  ET_phone_home="$(netstat -an | grep '\.2222\s.*ESTABLISHED' | head -n1 | awk '{ split($5, a, "."); print a[1] "." a[2] "." a[3] "." a[4] }')"  
  if [ -n "$ET_phone_home" ]; then
    sudo route -n add -net "$ET_phone_home/32" $DEFAULT_GW
  fi

  sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowDefault=true

else
  sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowGlobal=true
fi

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

printf "\nAuthorizing member..."
if [ "$(curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_API_TOKEN}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}' -o /dev/null -s -w "%{http_code}" )" != "200" ]; then
  printf "\n\nCould not authorize member."
  printf "\nEither the ZeroTier network ID or the ZeroTier API token is incorrect. Please check the respective values."
  exit 1
else
  printf "\nThis ZeroTier member is now authorized.\n\n"
fi

printf "\nJoining ZeroTier network..."
sudo zerotier-cli join "${!PARAM_ZT_NET_ID}"

printf "\nContacting remote ZeroTier member"
until ping -c1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

printf "\nLink with ZeroTier member \"%s\" successfully established." "$PARAM_ZT_REMOTE_MBR"