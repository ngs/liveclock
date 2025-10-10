#!/bin/bash

# Select Xcode Script
# Selects the latest stable Xcode version (excluding beta)

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Selecting latest stable Xcode...${NC}"

# Find the latest stable Xcode version (excluding beta)
XCODE_PATH=$(ls -d /Applications/Xcode_*.app 2>/dev/null | grep -v beta | sort -V | tail -n 1)

if [ -z "$XCODE_PATH" ]; then
    echo -e "${RED}No stable Xcode installation found${NC}"
    exit 1
fi

echo -e "${GREEN}Selected Xcode: $XCODE_PATH${NC}"
sudo xcode-select -s "$XCODE_PATH"

# Display selected Xcode version
echo -e "${GREEN}Xcode version:${NC}"
xcodebuild -version
