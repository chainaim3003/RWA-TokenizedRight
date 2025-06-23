# Institutional RWA Forte

Complete institutional Real-World Asset platform using Forte Rules Engine with comprehensive 14-rule compliance system.

Built on the proven [rwa-demo](https://github.com/dmulvi/rwa-demo) foundation with institutional-grade enhancements.

## 🎯 Features

- **14 Comprehensive Rules** - Full institutional compliance including ZK PRET integrations
- **Real Forte SDK** - Uses official `@thrackle-io/forte-rules-engine-sdk`
- **ZK PRET Integration** - Mock implementations for GLEIF, BPMN, ACTUS, DCSA
- **PYUSD Cross-Border** - Rules 13-14 for international PYUSD compliance
- **Proper Architecture** - Extends RulesEngineClient with auto-generated modifiers
- **Reference Implementation** - Includes original rwa-demo contracts for learning

## 📁 Project Structure

```
institutional-rwa-forte/
├── src/
│   ├── InstitutionalRWA.sol              # 🏛️ Main institutional ERC721 contract
│   ├── InstitutionalRWAFRE.sol           # 🔗 Forte Rules Engine modifiers (14 rules)
│   ├── InstitutionalComplianceMock.sol   # 🤖 Mock contract implementing all 14 rules
│   └── reference/                        # 📚 Original rwa-demo contracts
│       ├── Fraction.sol                  #     Simple RWA token (for learning)
│       └── FractionFRE.sol              #     Basic Forte integration
├── policies/
│   ├── institutional-complete.json       # 🏛️ Complete 14-rule Forte policy
│   └── reference/                        # 📚 Original rwa-demo policies
│       ├── kyc-level.json               #     Simple KYC policy
│       └── ofac-deny-erc721.json        #     Basic OFAC policy
├── script/
│   └── DeployInstitutional.s.sol         # 🚀 Deployment script
├── sdk.ts                                # 🔧 Forte SDK integration
├── anvilState.json                       # ⚡ Rules Engine deployment state
└── demo-all-14-rules.sh                 # 🧪 Comprehensive test script
```

## 📋 Rule Coverage

### Institutional Rules (RULE_01 - RULE_12)
Applied to `mintInstitutionalAsset()` function:

- **RULE_01**: Enhanced KYC + GLEIF verification
- **RULE_02**: Enhanced OFAC real-time check  
- **RULE_03**: Cross-border sanctions screening
- **RULE_04**: GLEIF corporate registration (ZK PRET)
- **RULE_05**: BPMN business process compliance (ZK PRET)
- **RULE_06**: ACTUS risk assessment (ZK PRET)
- **RULE_07**: DCSA trade document integrity (ZK PRET)
- **RULE_08**: Optimal fraction calculation
- **RULE_09**: Metadata completeness score
- **RULE_10**: Minimum fraction threshold
- **RULE_11**: Fraction liquidity optimization
- **RULE_12**: Enhanced metadata enforcement

### PYUSD Rules (RULE_13 - RULE_14)
Applied to `mintInstitutionalAssetPYUSD()` function:

- **RULE_13**: PYUSD stablecoin peg verification
- **RULE_14**: Cross-border PYUSD settlement compliance

### Reference Rules (From rwa-demo)
Applied to basic `mint()` and `_update()` functions:

- **Basic KYC**: KYC level > 2 for minting
- **Basic OFAC**: No sanctioned addresses for transfers

## 🚀 Quick Start

### 1. Environment Setup
```bash
# Copy environment template
cp .env.sample .env

# Install dependencies  
npm install

# Copy anvil state with deployed Rules Engine
bash copy-anvil-state.sh
```

### 2. Start Anvil with Forte State
```bash
# Load the state containing deployed Rules Engine
anvil --load-state anvilState.json
```

### 3. Deploy Contracts
```bash
# Deploy the institutional compliance system
forge script script/DeployInstitutional.s.sol --rpc-url $RPC_URL --private-key $PRIV_KEY --broadcast
```

### 4. Setup Forte Policy
```bash
# Create the institutional policy in the Rules Engine
npx tsx sdk.ts setupPolicy policies/institutional-complete.json
```

### 5. Inject Modifiers  
```bash
# Generate and inject compliance modifiers
npx tsx sdk.ts injectModifiers policies/institutional-complete.json src/InstitutionalRWAFRE.sol src/InstitutionalRWA.sol
```

### 6. Apply Policy to Contract
```bash
# Apply the policy to the deployed contract
npx tsx sdk.ts applyPolicy <POLICY_ID> <INSTITUTIONAL_RWA_ADDRESS>
```

## 🧪 Learning Path: Simple → Institutional

### Start with Reference Implementation
```bash
# 1. Deploy simple Fraction contract (from rwa-demo)
forge script script/DeployFraction.s.sol --rpc-url $RPC_URL --private-key $PRIV_KEY --broadcast

# 2. Setup basic KYC policy
npx tsx sdk.ts setupPolicy policies/reference/kyc-level.json

# 3. Test simple compliance
cast send <FRACTION_ADDRESS> "mint(address,uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 1 --rpc-url $RPC_URL --private-key $PRIV_KEY
```

### Progress to Institutional
```bash
# 1. Deploy institutional contracts
# 2. Setup 14-rule policy  
# 3. Test comprehensive compliance
bash demo-all-14-rules.sh
```

## 🧪 Testing Compliance Scenarios

### ✅ Compliant Test Cases

**High KYC User (Level 4):**
```solidity
// Address: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
// This address has KYC level 4 - will pass RULE_01
```

**Valid GLEIF LEI:**
```solidity
LEI: "HWUPKR0MPOU8FGXBT394"
Corporate Name: "APPLE INC"
// Pre-configured in mock contract - will pass RULE_04
```

**Compliant Asset Type:**
```solidity
Asset Type: "SUPPLY_CHAIN_INVOICE"
Principal Amount: 5000000 (meets minimum thresholds)
// Will pass metadata and threshold rules
```

### ❌ Non-Compliant Test Cases

**Low KYC User (Level 2):**
```solidity
// Address: 0x3C44CdDdB6a900fa2b585dd299e07d12A1F38Fa9  
// This address has KYC level 2 - will FAIL RULE_01
```

**OFAC Sanctioned Address:**
```solidity
// Address: 0x1111111111111111111111111111111111111111
// Pre-configured as sanctioned - will FAIL RULE_02
```

**Invalid LEI:**
```solidity
LEI: "INVALIDLEI123456789"
Corporate Name: "INVALID CORP"
// Not in GLEIF database - will FAIL RULE_04
```

## 🔧 Architecture Comparison

### Reference Implementation (rwa-demo)
```
Simple RWA Token
├── Basic KYC check (level > 2)
├── Basic OFAC check (not on list)  
├── Simple ERC721 functionality
└── 2 rules total
```

### Institutional Implementation (Our Enhancement)
```
Institutional RWA Token
├── Enhanced KYC + GLEIF verification
├── Multi-jurisdictional sanctions screening
├── ZK PRET integrations (GLEIF, BPMN, ACTUS, DCSA)
├── Metadata completeness scoring
├── Fraction optimization algorithms  
├── PYUSD cross-border compliance
└── 14 comprehensive rules total
```

## 🎮 Demo Scripts

### Simple Demo (Reference)
```bash
# Test basic rwa-demo functionality
npx tsx sdk.ts setupPolicy policies/reference/kyc-level.json
# Deploy and test simple fraction token
```

### Comprehensive Demo (Institutional)
```bash
# Test all 14 institutional rules
bash demo-all-14-rules.sh
```

## ✅ Success Criteria

When properly configured, the system will:
1. ✅ Accept compliant institutional transactions (all 14 rules pass)
2. ❌ Reject transactions failing any rule with specific error messages
3. 🔗 Demonstrate real Forte Rules Engine integration (not mock)
4. 📊 Show ZK PRET mock capabilities working within Forte framework
5. 🌍 Handle PYUSD cross-border compliance scenarios
6. 📚 Provide learning path from simple to institutional RWA

## 🏗️ Why Keep Reference Files?

1. **Learning Path**: Start simple, progress to institutional
2. **Testing**: Validate basic Forte functionality first
3. **Comparison**: See evolution from basic to institutional RWA
4. **Troubleshooting**: Known working examples for debugging
5. **Team Onboarding**: Easier to understand with progression

## 🚨 Important Notes

- Reference files show proven working Forte patterns
- Institutional files demonstrate advanced compliance capabilities
- Both use the same underlying Forte Rules Engine
- Mock ZK PRET can be replaced with real implementations
- All business logic from perm4-1 has been preserved and enhanced
