#!/bin/bash

echo "🏛️ RWA-TokenizedRight v4.0 - Complete Setup"
echo "============================================="
echo "📍 Working directory: $(pwd)"
echo ""

# Check current directory
if [[ ! "$(pwd)" == *"RWA-TokenizedRight"* ]]; then
    echo "⚠️  Warning: Not in RWA-TokenizedRight directory"
    echo "Current: $(pwd)"
    echo "Expected: .../RWA-TokenizedRight"
    echo ""
fi

# Step 1: Check critical anvil state
echo "📋 Step 1: Checking anvil state..."
if [ ! -f "anvilState.json" ]; then
    echo "❌ anvilState.json not found in current directory"
    echo "💡 Looking for rwa-demo in parent directory..."
    if [ -f "../rwa-demo/anvilState.json" ]; then
        echo "📋 Found anvilState.json in ../rwa-demo/"
        cp ../rwa-demo/anvilState.json ./anvilState.json
        echo "✅ anvilState.json copied successfully"
    elif [ -f "../institutional-rwa-forte/anvilState.json" ]; then
        echo "📋 Found anvilState.json in ../institutional-rwa-forte/"
        cp ../institutional-rwa-forte/anvilState.json ./anvilState.json
        echo "✅ anvilState.json copied successfully"
    else
        echo "❌ anvilState.json not found in expected locations"
        echo "🔍 Please manually copy anvilState.json from rwa-demo project"
        echo "   Expected paths:"
        echo "   - ../rwa-demo/anvilState.json"
        echo "   - ../institutional-rwa-forte/anvilState.json"
        echo ""
    fi
else
    echo "✅ anvilState.json already exists ($(du -h anvilState.json | cut -f1))"
fi

# Step 2: Check and install NPM dependencies
echo ""
echo "📦 Step 2: Checking NPM dependencies..."
if [ ! -d "node_modules" ]; then
    echo "📦 Installing NPM dependencies..."
    npm install
    if [ $? -eq 0 ]; then
        echo "✅ NPM dependencies installed successfully"
    else
        echo "❌ Failed to install NPM dependencies"
    fi
else
    echo "✅ node_modules already exists"
    echo "📋 Checking for package updates..."
    npm install
fi

# Step 3: Check and install forge dependencies
echo ""
echo "🔨 Step 3: Checking forge dependencies..."
if [ ! -d "lib/forge-std" ]; then
    echo "🔨 Installing forge-std..."
    forge install foundry-rs/forge-std@v1.7.3 --no-commit
    if [ $? -eq 0 ]; then
        echo "✅ forge-std installed successfully"
    else
        echo "❌ Failed to install forge-std"
    fi
else
    echo "✅ forge-std already exists"
fi

if [ ! -d "lib/openzeppelin-contracts" ]; then
    echo "🔨 Installing OpenZeppelin contracts..."
    forge install OpenZeppelin/openzeppelin-contracts@v5.3.0 --no-commit
    if [ $? -eq 0 ]; then
        echo "✅ OpenZeppelin contracts installed successfully"
    else
        echo "❌ Failed to install OpenZeppelin contracts"
    fi
else
    echo "✅ OpenZeppelin contracts already exist"
fi

# Step 4: Setup environment file
echo ""
echo "⚙️ Step 4: Setting up environment..."
if [ ! -f ".env" ]; then
    if [ -f ".env.sample" ]; then
        cp .env.sample .env
        echo "✅ .env file created from template"
        echo "📝 Default configuration loaded:"
        echo "   - Rules Engine: 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6"
        echo "   - RPC URL: http://127.0.0.1:8545"
        echo "   - Test addresses with different KYC levels configured"
    else
        echo "❌ .env.sample not found"
    fi
else
    echo "✅ .env file already exists"
fi

# Step 5: Build contracts
echo ""
echo "🏗️ Step 5: Building contracts..."
if [ -f "foundry.toml" ]; then
    forge build
    if [ $? -eq 0 ]; then
        echo "✅ All contracts built successfully"
        echo "📋 Compiled contracts available in out/ directory"
    else
        echo "❌ Failed to build contracts"
        echo "💡 Check for compilation errors above"
    fi
else
    echo "❌ foundry.toml not found"
    echo "💡 Make sure you're in the correct directory"
fi

# Step 6: Verify setup
echo ""
echo "🔍 Step 6: Verifying setup..."

# Check critical files
echo "📋 Checking critical files:"
[ -f "anvilState.json" ] && echo "✅ anvilState.json ($(du -h anvilState.json | cut -f1))" || echo "❌ anvilState.json missing"
[ -f ".env" ] && echo "✅ .env configuration file" || echo "❌ .env missing"
[ -f "package.json" ] && echo "✅ package.json ($(grep '"version"' package.json | cut -d'"' -f4))" || echo "❌ package.json missing"
[ -d "node_modules" ] && echo "✅ node_modules ($(ls node_modules | wc -l) packages)" || echo "❌ node_modules missing"
[ -d "lib" ] && echo "✅ lib/ forge dependencies" || echo "❌ lib/ missing"
[ -d "out" ] && echo "✅ out/ compiled contracts" || echo "❌ out/ missing"

# Check key contracts
echo ""
echo "📋 Checking key contracts:"
[ -f "src/InstitutionalRWA.sol" ] && echo "✅ InstitutionalRWA.sol (main contract)" || echo "❌ InstitutionalRWA.sol missing"
[ -f "src/InstitutionalComplianceMock.sol" ] && echo "✅ InstitutionalComplianceMock.sol (14 rules)" || echo "❌ InstitutionalComplianceMock.sol missing"
[ -f "policies/institutional-complete.json" ] && echo "✅ institutional-complete.json (14-rule policy)" || echo "❌ institutional-complete.json missing"

echo ""
echo "🎯 Setup Status Summary:"
echo "========================="

# Count what's ready
READY_COUNT=0
TOTAL_COUNT=7

[ -f "anvilState.json" ] && ((READY_COUNT++))
[ -f ".env" ] && ((READY_COUNT++))
[ -d "node_modules" ] && ((READY_COUNT++))
[ -d "lib/forge-std" ] && ((READY_COUNT++))
[ -d "out" ] && ((READY_COUNT++))
[ -f "src/InstitutionalRWA.sol" ] && ((READY_COUNT++))
[ -f "policies/institutional-complete.json" ] && ((READY_COUNT++))

echo "📊 Setup Progress: $READY_COUNT/$TOTAL_COUNT components ready"

if [ $READY_COUNT -eq $TOTAL_COUNT ]; then
    echo "🎉 SETUP COMPLETE! All components ready."
    echo ""
    echo "🚀 Next Steps (in order):"
    echo "========================="
    echo ""
    echo "1. 🔥 Start anvil with Rules Engine (NEW TERMINAL):"
    echo "   cd $(pwd)"
    echo "   anvil --load-state anvilState.json"
    echo ""
    echo "2. 🏛️ Deploy institutional contracts (THIS TERMINAL):"
    echo "   npm run deploy-institutional"
    echo ""
    echo "3. 🏷️ Create version 4.0 git commit:"
    echo "   bash git-version-4.0.sh"
    echo ""
    echo "4. 📋 Setup institutional policy:"
    echo "   npm run setup-policy"
    echo ""
    echo "5. 🔧 Inject compliance modifiers:"
    echo "   npm run inject-modifiers"
    echo ""
    echo "6. 🎯 Apply policy to contract:"
    echo "   npm run apply-policy <POLICY_ID> <CONTRACT_ADDRESS>"
    echo ""
    echo "7. 🧪 Test all 14 rules:"
    echo "   npm run demo"
    echo ""
    echo "8. 🌐 Push to remote repository:"
    echo "   bash git-push-complete.sh"
    echo ""
    echo "✨ You're ready to deploy and test your institutional RWA platform!"
else
    echo "⚠️  Setup incomplete. Please address missing components above."
    echo ""
    echo "🔧 Common fixes:"
    echo "- Make sure you're in the RWA-TokenizedRight directory"
    echo "- Copy anvilState.json from rwa-demo project"
    echo "- Run 'forge install' manually if lib/ dependencies failed"
    echo "- Run 'npm install' manually if node_modules failed"
fi

echo ""
echo "📍 Current directory: $(pwd)"
echo "📁 Directory contents: $(ls -1 | wc -l) items"
