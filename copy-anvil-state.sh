#!/bin/bash
# Copy the critical anvilState.json from rwa-demo
echo "📋 Copying critical anvilState.json (contains deployed Rules Engine)..."

# Use absolute Windows path
SOURCE_PATH="C:/SATHYA/CHAINAIM3003/mcp-servers/rwa-demo/anvilState.json"
DEST_PATH="./anvilState.json"

if [ -f "$SOURCE_PATH" ]; then
    cp "$SOURCE_PATH" "$DEST_PATH"
    if [ -f "$DEST_PATH" ]; then
        echo "✅ anvilState.json copied successfully"
        echo "📊 File size: $(du -h anvilState.json)"
        echo "🎯 This file contains the deployed Forte Rules Engine state"
        echo "🔗 Rules Engine Address: 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6"
    else
        echo "❌ Failed to copy anvilState.json"
    fi
else
    echo "❌ Source file not found at: $SOURCE_PATH"
    echo "💡 Please check that rwa-demo exists in the parent directory"
fi
