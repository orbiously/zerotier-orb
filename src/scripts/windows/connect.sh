#!/bin/bash

MEMBER_ID=$(/c/progra~2/ZeroTier/One/zerotier-cli.bat info|cut -d " " -f3)

printf "\nAuthorizing member..."
if [ "$(curl --location --request POST "https://api.zerotier.com/api/v1/network/${!PARAM_ZT_NET_ID}/member/$MEMBER_ID" \
    --header "Authorization: bearer ${!PARAM_ZT_API_TOKEN}" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}' -o /dev/null -s -w "%{http_code}" )" != "200" ]; then
  printf "\n\nCould not authorize member."
  printf "\nEither the ZeroTier network ID or the ZeroTier API token is incorrect. Please check the respective values."
  exit 1
else
  printf "\nThis ZeroTier member is now authorized."
fi

/c/progra~2/ZeroTier/One/zerotier-cli.bat set "$ZT_NET_ID" allowGlobal=true

printf "\nJoining ZeroTier network..."
/c/progra~2/ZeroTier/One/zerotier-cli.bat join "$ZT_NET_ID"

# until /c/progra~2/ZeroTier/One/zerotier-cli.bat join "$ZT_NET_ID"; do
#   sleep 1
#   echo "Attempting to join ZeroTier network $ZT_NET_ID"
# done

printf "\nContacting remote ZeroTier member"
until ping -n 1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

printf "\nLink with ZeroTier member \"%s\" successfully established." "$PARAM_ZT_REMOTE_MBR"