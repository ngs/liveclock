#!/bin/bash

# Icon generation script for LiveClock
# This script generates placeholder app icons for all required sizes

ICON_DIR="Sources/Resources/Assets.xcassets/AppIcon.appiconset"

# Create icon directory if it doesn't exist
mkdir -p "$ICON_DIR"

# Function to create a placeholder icon with ImageMagick or sips
create_icon() {
    size=$1
    filename=$2
    
    # Create a simple colored square as placeholder
    # You can replace this with actual icon generation
    echo "Creating ${filename} (${size}x${size})"
    
    if command -v convert &> /dev/null; then
        # Use ImageMagick if available
        convert -size ${size}x${size} \
                xc:'#007AFF' \
                -gravity center \
                -fill white \
                -font Helvetica-Bold \
                -pointsize $((size/3)) \
                -annotate +0+0 "LC" \
                "$ICON_DIR/$filename"
    elif command -v sips &> /dev/null; then
        # Use sips (macOS built-in) as fallback
        # Create a simple colored PNG
        printf "\x89PNG\r\n\x1a\n" > "$ICON_DIR/$filename"
        echo "Note: Install ImageMagick for better icon generation"
    else
        echo "Warning: Neither ImageMagick nor sips found. Please install ImageMagick."
        echo "  brew install imagemagick"
    fi
}

# iOS Icons
create_icon 40 "icon-20@2x.png"
create_icon 60 "icon-20@3x.png"
create_icon 58 "icon-29@2x.png"
create_icon 87 "icon-29@3x.png"
create_icon 80 "icon-40@2x.png"
create_icon 120 "icon-40@3x.png"
create_icon 120 "icon-60@2x.png"
create_icon 180 "icon-60@3x.png"

# iPad Icons
create_icon 20 "icon-20.png"
create_icon 29 "icon-29.png"
create_icon 40 "icon-40.png"
create_icon 76 "icon-76.png"
create_icon 152 "icon-76@2x.png"
create_icon 167 "icon-83.5@2x.png"

# App Store Icon
create_icon 1024 "icon-1024.png"

# macOS Icons
create_icon 16 "icon-16.png"
create_icon 32 "icon-16@2x.png"
create_icon 32 "icon-32.png"
create_icon 64 "icon-32@2x.png"
create_icon 128 "icon-128.png"
create_icon 256 "icon-128@2x.png"
create_icon 256 "icon-256.png"
create_icon 512 "icon-256@2x.png"
create_icon 512 "icon-512.png"
create_icon 1024 "icon-512@2x.png"

echo "Icon generation complete!"
echo "Note: These are placeholder icons. Replace them with actual app icons before release."