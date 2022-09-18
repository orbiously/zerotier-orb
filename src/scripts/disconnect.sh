#!/bin/bash

if [ "$EXECUTOR" = "linux" ]; then eval "$SCRIPT_LEAVE_LINUX";
elif [ "$EXECUTOR" = "macos" ]; then eval "$SCRIPT_LEAVE_MACOS";
elif [ "$EXECUTOR" = "windows" ]; then eval "$SCRIPT_LEAVE_WINDOWS";
fi