#!/bin/bash

if [ "$PARAM_FULL_VPN" = 1 ]; then
  DEFAULT_GW="$(ip route show default|awk '{print $3}')"
  echo "Initial default gateway is $DEFAULT_GW"

  sudo ip route add 169.254.0.0/16 via "$DEFAULT_GW"

  ET_phone_home=$(ss -Hnto state established '( sport = :ssh )' | head -n1 | awk '{ split($4, a, ":"); print a[1] }')
  if [ -n "$ET_phone_home" ]; then
    sudo ip route add "$ET_phone_home"/32 via "$DEFAULT_GW"
    echo "Added route to $ET_phone_home/32 via default gateway"
  fi

  for IP in $(host runner.circleci.com | awk '{ print $4; }')
    do
      sudo ip route add "$IP"/32 via "$DEFAULT_GW"
      echo "Added route to $IP/32 via default gateway"
  done

  for RESCONF_DNS in $(systemd-resolve --status | grep 'DNS Servers'|awk '{print $3}')
    do
      sudo ip route add "$RESCONF_DNS"/32 via "$DEFAULT_GW"
      echo "Added route to $RESCONF_DNS/32 via default gateway"
  done

  sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowDefault=true

else
  sudo zerotier-cli set "${!PARAM_ZT_NET_ID}" allowGlobal=true

fi

MEMBER_ID=$(sudo zerotier-cli info|cut -d " " -f3)

printf "\nAuthorizing member..."
if [ "$(curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: token ${!PARAM_ZT_API_TOKEN}" \
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