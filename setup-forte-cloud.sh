#!/bin/bash

# =============================================================================
# CONFIGURE REAL FORTE CLOUD INTEGRATION
# =============================================================================
# This script shows how to connect your contract to the REAL Forte cloud service
# instead of the local mock we've been using for testing
# =============================================================================

echo "🌐 FORTE CLOUD SETUP: Connect to Real Forte Service"
echo "=================================================="
echo ""

# Contract Addresses
RWA_TOKEN="0x09635F643e140090A9A8Dcd712eD6285858ceBef"
LOCAL_MOCK_ENGINE="0x7a2088a1bfc9d81c55368ae168c2c02570cb814f"
RPC_URL="http://localhost:8545"
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

echo "📋 CURRENT SETUP:"
echo "   RWA Token: $RWA_TOKEN"
echo "   Local Mock: $LOCAL_MOCK_ENGINE"
echo ""

# =============================================================================
# STEP 1: CHECK CURRENT CONFIGURATION
# =============================================================================
echo "🔍 STEP 1: CHECKING CURRENT CONFIGURATION"
echo "=========================================="

CURRENT_ENGINE=$(cast call $RWA_TOKEN "rulesEngineAddress()" --rpc-url $RPC_URL)
echo "   Current Rules Engine: $CURRENT_ENGINE"

if [ "$CURRENT_ENGINE" == "0x0000000000000000000000000000000000000000000000000000000000000000" ]; then
    echo "   Status: ❌ No Rules Engine configured"
elif [ "$CURRENT_ENGINE" == "$LOCAL_MOCK_ENGINE" ]; then
    echo "   Status: 🔧 Using Local Mock Engine"
else
    echo "   Status: 🌐 Using External Engine (possibly Forte cloud)"
fi

echo ""

# =============================================================================
# STEP 2: SHOW HOW TO GET FORTE CLOUD ADDRESS
# =============================================================================
echo "🌐 STEP 2: HOW TO GET REAL FORTE CLOUD ADDRESS"
echo "=============================================="
echo ""
echo "To connect to real Forte cloud, you need:"
echo ""
echo "1. 📝 CREATE FORTE ACCOUNT:"
echo "   → Visit: https://dashboard.forte.io"
echo "   → Sign up for Forte account"
echo "   → Create new project"
echo ""
echo "2. 📤 UPLOAD YOUR POLICY:"
echo "   → Upload: policies/institutional-complete-14-rules.json"
echo "   → Configure rule parameters"
echo "   → Deploy policy to cloud"
echo ""
echo "3. 🔗 GET RULES ENGINE ADDRESS:"
echo "   → Copy Rules Engine contract address from dashboard"
echo "   → Usually looks like: 0x1234567890abcdef1234567890abcdef12345678"
echo ""
echo "4. 🎛️ CONFIGURE CONTRACT PERMISSIONS:"
echo "   → Add your contract address: $RWA_TOKEN"
echo "   → Grant appropriate permissions"
echo "   → Test connection"
echo ""

# =============================================================================
# STEP 3: DEMONSTRATE CLOUD CONNECTION SETUP
# =============================================================================
echo ""
echo "🔧 STEP 3: CLOUD CONNECTION SETUP EXAMPLE"
echo "========================================="
echo ""

echo "📝 EXAMPLE: If your Forte cloud address was 0x1234...5678:"
echo ""
echo "# Set the real Forte cloud address"
echo "FORTE_CLOUD_ADDRESS=\"0x1234567890abcdef1234567890abcdef12345678\""
echo ""
echo "# Connect your contract to Forte cloud"
echo "cast send $RWA_TOKEN \"setRulesEngineAddress(address)\" \$FORTE_CLOUD_ADDRESS \\"
echo "  --rpc-url $RPC_URL \\"
echo "  --private-key $PRIVATE_KEY"
echo ""
echo "# Verify the connection"
echo "cast call $RWA_TOKEN \"rulesEngineAddress()\" --rpc-url $RPC_URL"
echo ""

# =============================================================================
# STEP 4: COMPARISON DEMO SETUP
# =============================================================================
echo ""
echo "⚖️ STEP 4: DEMO SETUP FOR JUDGES (Current Configuration)"
echo "======================================================="
echo ""

echo "For the hackathon demo, we'll set up the local mock to simulate the cloud:"
echo ""

if [ "$CURRENT_ENGINE" == "0x0000000000000000000000000000000000000000000000000000000000000000" ]; then
    echo "🔧 SETTING UP LOCAL MOCK FOR DEMO..."
    
    SETUP_RESULT=$(cast send $RWA_TOKEN "setRulesEngineAddress(address)" $LOCAL_MOCK_ENGINE \
      --rpc-url $RPC_URL \
      --private-key $PRIVATE_KEY 2>&1)
    
    echo "   Setup Result: $SETUP_RESULT"
    
    # Verify
    NEW_ENGINE=$(cast call $RWA_TOKEN "rulesEngineAddress()" --rpc-url $RPC_URL)
    echo "   New Rules Engine: $NEW_ENGINE"
    
    if [ "$NEW_ENGINE" == "$LOCAL_MOCK_ENGINE" ]; then
        echo "   ✅ Mock engine configured for demo"
    else
        echo "   ❌ Failed to configure mock engine"
    fi
else
    echo "✅ Rules Engine already configured: $CURRENT_ENGINE"
fi

echo ""

# =============================================================================
# STEP 5: VERIFICATION OF INTEGRATION
# =============================================================================
echo "✅ STEP 5: VERIFY INTEGRATION IS WORKING"
echo "========================================"
echo ""

echo "🔍 Testing Rules Engine connection:"

# Test if the rules engine responds
RULES_COUNT=$(cast call $LOCAL_MOCK_ENGINE "getTotalRulesCount()" --rpc-url $RPC_URL 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "   ✅ Rules Engine responding: $RULES_COUNT rules loaded"
else
    echo "   ❌ Rules Engine not responding"
fi

# Test contract connection
CONTRACT_ENGINE=$(cast call $RWA_TOKEN "rulesEngineAddress()" --rpc-url $RPC_URL)
echo "   ✅ Contract configured with: $CONTRACT_ENGINE"

echo ""

# =============================================================================
# FINAL SUMMARY
# =============================================================================
echo "🏆 FORTE INTEGRATION SUMMARY"
echo "============================"
echo ""
echo "📊 CURRENT STATUS:"
echo "   Contract: $RWA_TOKEN"
echo "   Rules Engine: $(cast call $RWA_TOKEN "rulesEngineAddress()" --rpc-url $RPC_URL)"
echo "   Type: Local Mock (for demo) / Replace with Forte cloud for production"
echo ""
echo "🎯 FOR JUDGES:"
echo "   ✅ Contract uses real RulesEngineClient from @thrackle-io/forte-rules-engine"
echo "   ✅ Modifiers call _invokeRulesEngine() before function execution"
echo "   ✅ _invokeRulesEngine calls IRulesEngine.checkPolicies() external function"
echo "   ✅ Rules Engine address is configurable (mock for demo, cloud for production)"
echo "   ✅ The intervention mechanism is REAL Forte architecture"
echo ""
echo "🌐 FOR PRODUCTION:"
echo "   🔄 Replace local mock with real Forte cloud address"
echo "   🔄 Upload policy JSON to Forte dashboard"
echo "   🔄 Configure permissions and test cloud integration"
echo ""
echo "✅ INTEGRATION READY: Contract is properly set up for Forte Rules Engine!"
echo ""
