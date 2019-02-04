#!/bin/bash

PROJECT_FILE=$1

if [ -z "${PROJECT_FILE}" ]; then
    PROJECT_FILE=$(find . -maxdepth 1 -name '*.xcodeproj')
fi

if [ -z "${PROJECT_FILE}" ]; then
    echo "Failed to find a .xcodeproj file" >&2
    exit 1
fi

DERIVED_DATA_DIR=$(xcodebuild -project "${PROJECT_FILE}" -showBuildSettings | grep -m 1 "DerivedData/" | cut -d '=' -f 2 | sed 's/[[:space:]]*\([a-zA-Z\/]*\/Library\/Developer\/Xcode\/DerivedData\/[a-zA-Z\-]*\).*/\1/')

# Validate directory
if [ "$(dirname ${DERIVED_DATA_DIR})" = "${HOME}/Library/Developer/Xcode/DerivedData" ]; then
    set -x
    rm -r "${DERIVED_DATA_DIR}"
else
    echo "Failed to find a valid derived data directory" >&2
    exit 1
fi

