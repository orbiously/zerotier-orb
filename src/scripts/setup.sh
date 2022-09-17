#!/bin/bash

case $(uname) in
  [Ll]inux*)
    if [ -f /.dockerenv ]; then
      printf "The ZeroTier orb does not support the 'docker' executor.\n"
      printf "Please use the Linux 'machine' executor instead."
      exit 1
    else
      export EXECUTOR=linux
    fi
    ;;
  [Dd]arwin*)
    export EXECUTOR=macos
    ;;
  msys*|MSYS*|nt|win*)
    export EXECUTOR=windows
    ;;
esac

echo "Checking if required environment variables are set"
echo "=================================================="

if [ -z "${!PARAM_ZT_NET_ID}" ]; then 
  printf "\nThe environment variable that should contain your ZeroTier network ID is not set or accessible.\n\n"
  if [ "${PARAM_ZT_NET_ID}" != "ZT_NET_ID" ]; then
    echo "> Make sure to store the ZeroTier network ID in the environment variable you specified via the \`net-id-var\` parameter: \"${PARAM_ZT_NET_ID}\"."
  else
    echo "> In case you stored the ZeroTier network ID in an environment variable with a different name than ZT_NET_ID, you need to specify that custom name via the \`net-id-var\` parameter."
  fi
  echo "> If the environment variable ${PARAM_ZT_NET_ID} is declared in an organization context, the context name must be referenced in the workflow."
  exit 1
fi

if [ -z "${!PARAM_ZT_API_TOKEN}" ]; then 
  printf "The environment variable that should contain your ZeroTier API token is not set or accessible.\n\n"
  if [ "${PARAM_ZT_API_TOKEN}" != "ZT_API_TOKEN" ]; then
    echo "> Make sure to store the ZeroTier API token in the environment variable you specified via the \`net-id-var\` parameter: \"${PARAM_ZT_API_TOKEN}\"."
  else
    echo "> In case you stored the ZeroTier API token in an environment variable with a different name than ZT_API_TOKEN, you need to specify that custom name via the \`api-token-var\` parameter."
  fi
  echo "> If the environment variable ${PARAM_ZT_API_TOKEN} is declared in an organization context, the context name must be referenced in the workflow."
  exit 1
fi

printf "\nEnvironment variables check: OK\n"


if [ "$EXECUTOR" = "linux" ]; then eval "$SCRIPT_SETUP_LINUX";
elif [ "$EXECUTOR" = "macos" ]; then eval "$SCRIPT_SETUP_MACOS";
elif [ "$EXECUTOR" = "windows" ]; then eval "$SCRIPT_SETUP_WINDOWS";
fi
