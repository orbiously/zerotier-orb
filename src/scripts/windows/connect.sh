#!/bin/bash

MEMBER_ID=$(/c/progra~2/ZeroTier/One/zerotier-cli.bat info|cut -d " " -f3)

curl --location --request POST "https://my.zerotier.com/api/v1/network/$ZT_NET_ID/member/$MEMBER_ID" \
    --header "Authorization: bearer $ZT_API_TOKEN" \
    --header 'Content-Type: text/plain' \
    --data-raw '{"config": {"authorized": true}}'

/c/progra~2/ZeroTier/One/zerotier-cli.bat set "$ZT_NET_ID" allowGlobal=true

echo "Joining ZeroTier network..."
/c/progra~2/ZeroTier/One/zerotier-cli.bat join "$ZT_NET_ID"

# until /c/progra~2/ZeroTier/One/zerotier-cli.bat join "$ZT_NET_ID"; do
#   sleep 1
#   echo "Attempting to join ZeroTier network $ZT_NET_ID"
# done

echo "Contacting remote ZeroTier member"
until ping -n 1 "$PARAM_ZT_REMOTE_MBR"; do
  sleep 1
  echo "Still attempting to reach remote ZeroTier member"
done

echo "Link with ZeroTier member \"$PARAM_ZT_REMOTE_MBR\" successfully established."