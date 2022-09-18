#!/bin/bash

if [ "$EXECUTOR" = "linux" ]; then eval "$SCRIPT_CONNECT_LINUX";
elif [ "$EXECUTOR" = "macos" ]; then eval "$SCRIPT_CONNECT_MACOS";
elif [ "$EXECUTOR" = "windows" ]; then eval "$SCRIPT_CONNECT_WINDOWS";
fi