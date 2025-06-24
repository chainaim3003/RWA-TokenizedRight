#!/bin/bash

echo "🏛️ RWA-TokenizedRight v4.0 - Fixed Setup"
echo "========================================"
echo "📍 Working directory: $(pwd)"
echo ""

# Step 1: Check critical anvil state
echo "📋 Step 1: Checking anvil state..."
if [ -f "anvilState.json" ]; then
    echo "✅ anvilState.json already exists ($(du -h anvilState.json | cut -f1))"
else
    echo "❌ anvilState.json not found - copying from rwa-demo..."
    if [ -f "../rwa-demo/anvilState.json" ]; then
        cp ../rwa-demo/anvilState.json ./anvilState.json
        echo "✅ anvilState.json copied successfully"
    else
        echo "❌ Cannot find anvilState.json in ../rwa-demo/"
    fi
fi

# Step 2: Install NPM dependencies
echo ""
echo "📦 Step 2: NPM dependencies..."
if [ -d "node_modules" ]; then
    echo "✅ node_modules already exists"
else
    echo "📦 Installing NPM dependencies..."
    npm install
fi

# Step 3: Install forge dependencies (FIXED)
echo ""
echo "🔨 Step 3: Installing forge dependencies..."

# Remove lib directory if it has issues
if [ -d "lib" ] && [ ! -d "lib/forge-std" ]; then
    echo "🧹 Cleaning up incomplete lib directory..."
    rm -rf lib
fi

# Install forge-std without --no-commit flag
if [ ! -d "lib/forge-std" ]; then
    echo "🔨 Installing forge-std..."
    forge install foundry-rs/forge-std@v1.7.3
    if [ $? -eq 0 ]; then
        echo "✅ forge-std installed successfully"
    else
        echo "❌ Failed to install forge-std, trying alternative..."
        forge install foundry-rs/forge-std
    fi
else
    echo "✅ forge-std already exists"
fi

# Install OpenZeppelin contracts without --no-commit flag
if [ ! -d "lib/openzeppelin-contracts" ]; then
    echo "🔨 Installing OpenZeppelin contracts..."
    forge install OpenZeppelin/openzeppelin-contracts@v5.3.0
    if [ $? -eq 0 ]; then
        echo "✅ OpenZeppelin contracts installed successfully"
    else
        echo "❌ Failed to install OpenZeppelin contracts, trying alternative..."
        forge install OpenZeppelin/openzeppelin-contracts
    fi
else
    echo "✅ OpenZeppelin contracts already exist"
fi

# Step 4: Setup environment
echo ""
echo "⚙️ Step 4: Environment setup..."
if [ ! -f ".env" ]; then
    cp .env.sample .env
    echo "✅ .env file created from template"
else
    echo "✅ .env file already exists"
fi

# Step 5: Fix unicode issues in contracts
echo ""
echo "🔧 Step 5: Fixing unicode issues in deployment scripts..."

# Fix DeployInstitutional.s.sol
if [ -f "script/DeployInstitutional.s.sol" ]; then
    echo "🔧 Fixing DeployInstitutional.s.sol..."
    sed -i 's/console\.log("🏛️ Deploying Institutional RWA System");/console.log("Deploying Institutional RWA System");/g' script/DeployInstitutional.s.sol
    sed -i 's/console\.log("📋 Deploying Institutional Compliance Mock\.\.\.");/console.log("Deploying Institutional Compliance Mock...");/g' script/DeployInstitutional.s.sol
    sed -i 's/console\.log("✅ Compliance Mock deployed at:", address(complianceMock));/console.log("Compliance Mock deployed at:", address(complianceMock));/g' script/DeployInstitutional.s.sol
    sed -i 's/console\.log("🏢 Deploying Institutional RWA Contract\.\.\.");/console.log("Deploying Institutional RWA Contract...");/g' script/DeployInstitutional.s.sol
    sed -i 's/console\.log("✅ Institutional RWA deployed at:", address(institutionalRWA));/console.log("Institutional RWA deployed at:", address(institutionalRWA));/g' script/DeployInstitutional.s.sol
    echo "✅ Fixed DeployInstitutional.s.sol"
fi

# Fix DeployFraction.s.sol
if [ -f "script/reference/DeployFraction.s.sol" ]; then
    echo "🔧 Fixing DeployFraction.s.sol..."
    sed -i 's/console\.log("📋 Deploying reference Fraction contract\.\.\.");/console.log("Deploying reference Fraction contract...");/g' script/reference/DeployFraction.s.sol
    sed -i 's/console\.log("✅ Reference Fraction deployed at:", address(fraction));/console.log("Reference Fraction deployed at:", address(fraction));/g' script/reference/DeployFraction.s.sol
    sed -i 's/console\.log("🎯 Use this for testing basic Forte functionality");/console.log("Use this for testing basic Forte functionality");/g' script/reference/DeployFraction.s.sol
    echo "✅ Fixed DeployFraction.s.sol"
fi

# Step 6: Build contracts
echo ""
echo "🏗️ Step 6: Building contracts..."
forge build

if [ $? -eq 0 ]; then
    echo "✅ All contracts built successfully"
else
    echo "❌ Build failed - checking for remaining issues..."
    echo ""
    echo "🔍 Checking lib directory structure:"
    ls -la lib/ 2>/dev/null || echo "lib/ directory not found"
    echo ""
    echo "🔍 Forge remappings:"
    forge remappings
fi

# Step 7: Final verification
echo ""
echo "🔍 Final verification..."
echo "📋 Critical files:"
[ -f "anvilState.json" ] && echo "✅ anvilState.json" || echo "❌ anvilState.json missing"
[ -f ".env" ] && echo "✅ .env" || echo "❌ .env missing"
[ -d "node_modules" ] && echo "✅ node_modules" || echo "❌ node_modules missing"
[ -d "lib/forge-std" ] && echo "✅ lib/forge-std" || echo "❌ lib/forge-std missing"
[ -d "lib/openzeppelin-contracts" ] && echo "✅ lib/openzeppelin-contracts" || echo "❌ lib/openzeppelin-contracts missing"
[ -d "out" ] && echo "✅ out/ (compiled contracts)" || echo "❌ out/ missing (compilation failed)"

echo ""
if [ -d "out" ] && [ -d "lib/forge-std" ] && [ -f "anvilState.json" ]; then
    echo "🎉 SETUP COMPLETE!"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Start anvil: anvil --load-state anvilState.json"
    echo "2. Deploy contracts: npm run deploy-institutional"
    echo "3. Setup policy: npm run setup-policy"
    echo "4. Run demo: npm run demo"
else
    echo "⚠️ Setup incomplete - check errors above"
    echo ""
    echo "🔧 Manual fixes if needed:"
    echo "1. forge install foundry-rs/forge-std"
    echo "2. forge install OpenZeppelin/openzeppelin-contracts"
    echo "3. forge build"
fi
