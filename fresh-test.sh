#!/bin/bash

echo "🧪 Fresh Test Script: RWA-TokenizedRight"
echo "======================================="

# Load environment with explicit variable setting
export RPC_URL=http://127.0.0.1:8545
export RULES_ENGINE_ADDRESS=0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6
export USER_ADDRESS=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
export PRIV_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

echo "✅ Environment set manually"
echo "RPC_URL: $RPC_URL"
echo "RULES_ENGINE_ADDRESS: $RULES_ENGINE_ADDRESS"
echo ""

# Test anvil is running
echo "🌐 Testing anvil connection..."
if cast chain-id --rpc-url $RPC_URL > /dev/null 2>&1; then
    echo "✅ Anvil connected"
else
    echo "❌ Anvil not accessible"
    exit 1
fi

# Test parameter conversions
echo "🔄 Testing parameter conversions..."
npx tsx utils/policy-helper.ts convertParams

# Test compilation
echo "🔨 Testing compilation..."
forge build --silent

# Test deployment
echo "🚀 Testing deployment..."
forge script script/DeployModifiedPRET.s.sol --rpc-url $RPC_URL --private-key $PRIV_KEY --broadcast --silent

echo "✅ Fresh test completed!"
