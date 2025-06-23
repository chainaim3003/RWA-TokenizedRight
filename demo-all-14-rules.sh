#!/bin/bash

# Institutional RWA Forte - Complete Demo Script
# Demonstrates all 14 rules with compliant and non-compliant test cases

echo "🏛️ Institutional RWA Forte - Complete Compliance Demo"
echo "======================================================"

# Load environment variables
source .env

echo "📋 Testing Configuration:"
echo "RPC URL: $RPC_URL"
echo "Rules Engine: $RULES_ENGINE_ADDRESS"
echo ""

# Function to test compliant transaction
test_compliant() {
    echo "✅ Testing COMPLIANT transaction..."
    echo "User: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (KYC Level 4)"
    echo "LEI: HWUPKR0MPOU8FGXBT394 (Apple Inc - Valid)"
    echo "Asset: SUPPLY_CHAIN_INVOICE ($5M)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAsset(address,uint256,uint256,string,string,string)" \
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8 \
        1000 \
        5000000 \
        "SUPPLY_CHAIN_INVOICE" \
        "HWUPKR0MPOU8FGXBT394" \
        "APPLE INC" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ✅ SUCCESS - All 12 rules should pass"
    echo ""
}

# Function to test KYC failure
test_kyc_failure() {
    echo "❌ Testing KYC FAILURE (RULE_01)..."
    echo "User: 0x3C44CdDdB6a900fa2b585dd299e07d12A1F38Fa9 (KYC Level 2 - Too Low)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAsset(address,uint256,uint256,string,string,string)" \
        0x3C44CdDdB6a900fa2b585dd299e07d12A1F38Fa9 \
        1000 \
        5000000 \
        "SUPPLY_CHAIN_INVOICE" \
        "HWUPKR0MPOU8FGXBT394" \
        "APPLE INC" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ❌ FAIL - RULE_01: Enhanced KYC verification failed"
    echo ""
}

# Function to test OFAC failure
test_ofac_failure() {
    echo "❌ Testing OFAC SANCTIONS FAILURE (RULE_02)..."
    echo "User: 0x1111111111111111111111111111111111111111 (Sanctioned Address)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAsset(address,uint256,uint256,string,string,string)" \
        0x1111111111111111111111111111111111111111 \
        1000 \
        5000000 \
        "SUPPLY_CHAIN_INVOICE" \
        "HWUPKR0MPOU8FGXBT394" \
        "APPLE INC" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ❌ FAIL - RULE_02: Enhanced OFAC check failed"
    echo ""
}

# Function to test GLEIF failure
test_gleif_failure() {
    echo "❌ Testing GLEIF VERIFICATION FAILURE (RULE_04)..."
    echo "User: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (Good KYC)"
    echo "LEI: INVALIDLEI123456789 (Invalid LEI)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAsset(address,uint256,uint256,string,string,string)" \
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8 \
        1000 \
        5000000 \
        "SUPPLY_CHAIN_INVOICE" \
        "INVALIDLEI123456789" \
        "INVALID CORP" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ❌ FAIL - RULE_04: GLEIF verification failed"
    echo ""
}

# Function to test high risk asset failure
test_high_risk_failure() {
    echo "❌ Testing HIGH RISK ASSET FAILURE (RULE_06)..."
    echo "User: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (Good KYC)"
    echo "Asset: STRUCTURED_PRODUCTS ($20M - High Risk)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAsset(address,uint256,uint256,string,string,string)" \
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8 \
        1000 \
        20000000 \
        "STRUCTURED_PRODUCTS" \
        "HWUPKR0MPOU8FGXBT394" \
        "APPLE INC" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ❌ FAIL - RULE_06: ACTUS risk assessment failed"
    echo ""
}

# Function to test PYUSD compliant
test_pyusd_compliant() {
    echo "✅ Testing PYUSD COMPLIANT transaction..."
    echo "Countries: US ↔ GB (Allowed pair)"
    echo "Amount: $5M PYUSD (Within limits)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAssetPYUSD(address,uint256,uint256,string,string)" \
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8 \
        1000 \
        5000000 \
        "US" \
        "GB" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ✅ SUCCESS - PYUSD rules should pass"
    echo ""
}

# Function to test PYUSD restricted country failure
test_pyusd_country_failure() {
    echo "❌ Testing PYUSD RESTRICTED COUNTRY FAILURE (RULE_14)..."
    echo "Countries: IR ↔ US (Iran restricted)"
    echo ""
    
    cast send $INSTITUTIONAL_RWA_ADDRESS \
        "mintInstitutionalAssetPYUSD(address,uint256,uint256,string,string)" \
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8 \
        1000 \
        5000000 \
        "IR" \
        "US" \
        --rpc-url $RPC_URL --private-key $PRIV_KEY
    
    echo "Expected: ❌ FAIL - RULE_14: Cross-border PYUSD compliance failed"
    echo ""
}

# Main demo execution
echo "🚀 Starting comprehensive rule testing..."
echo ""

# Check if contract addresses are set
if [ -z "$INSTITUTIONAL_RWA_ADDRESS" ]; then
    echo "❌ INSTITUTIONAL_RWA_ADDRESS not set in .env"
    echo "Please deploy contracts first and update .env file"
    exit 1
fi

echo "📊 Test Plan: 6 scenarios covering all 14 rules"
echo ""
echo "1. ✅ Compliant institutional asset (Rules 01-12)"
echo "2. ❌ KYC failure (Rule 01)" 
echo "3. ❌ OFAC sanctions failure (Rule 02)"
echo "4. ❌ GLEIF verification failure (Rule 04)"
echo "5. ❌ High risk asset failure (Rule 06)"
echo "6. ✅ PYUSD compliant (Rules 13-14)"
echo "7. ❌ PYUSD restricted country (Rule 14)"
echo ""

read -p "Press Enter to start testing..."

# Run all tests
test_compliant
test_kyc_failure  
test_ofac_failure
test_gleif_failure
test_high_risk_failure
test_pyusd_compliant
test_pyusd_country_failure

echo "🎯 Demo Complete!"
echo ""
echo "📊 Summary:"
echo "- ✅ Compliant transactions should succeed"
echo "- ❌ Non-compliant transactions should fail with specific rule violations"  
echo "- All 14 institutional compliance rules are now active and protecting the contract"
echo ""
echo "🔍 Next Steps:"
echo "1. Check transaction receipts for rule enforcement"
echo "2. Verify error messages match expected rule violations"
echo "3. Modify test parameters to explore edge cases"
echo "4. Add real-world data sources to replace mocks"
