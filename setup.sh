#!/bin/bash

echo "🏛️ Institutional RWA Forte - Complete Setup"
echo "============================================="

# Step 1: Copy critical anvil state
echo "📋 Step 1: Copying anvil state with deployed Rules Engine..."
if [ ! -f "anvilState.json" ]; then
    cp ../rwa-demo/anvilState.json ./anvilState.json
    echo "✅ anvilState.json copied"
else
    echo "✅ anvilState.json already exists"
fi

# Step 2: Install dependencies
echo ""
echo "📦 Step 2: Installing dependencies..."
npm install

# Step 3: Install forge dependencies
echo ""
echo "🔨 Step 3: Installing forge dependencies..."
forge install foundry-rs/forge-std@v1.7.3 --no-commit
forge install OpenZeppelin/openzeppelin-contracts@v5.3.0 --no-commit

# Step 4: Setup environment
echo ""
echo "⚙️ Step 4: Setting up environment..."
if [ ! -f ".env" ]; then
    cp .env.sample .env
    echo "✅ .env file created from template"
    echo "⚠️  Please edit .env with your configuration"
else
    echo "✅ .env file already exists"
fi

# Step 5: Build contracts
echo ""
echo "🏗️ Step 5: Building contracts..."
forge build

echo ""
echo "🎯 Setup Complete! Next steps:"
echo "================================"
echo ""
echo "1. 📝 Edit .env file with your configuration"
echo ""
echo "2. 🚀 Start anvil with Rules Engine:"
echo "   anvil --load-state anvilState.json"
echo ""
echo "3. 🏛️ Deploy institutional contracts:"
echo "   npm run deploy-institutional"
echo ""
echo "4. 📋 Setup institutional policy:"
echo "   npm run setup-policy"
echo ""
echo "5. 🔧 Inject modifiers:"
echo "   npm run inject-modifiers"
echo ""
echo "6. 🎯 Apply policy to contract:"
echo "   npm run apply-policy <POLICY_ID> <CONTRACT_ADDRESS>"
echo ""
echo "7. 🧪 Run comprehensive demo:"
echo "   npm run demo"
echo ""
echo "📚 OR start with reference implementation:"
echo "   npm run deploy-reference  # Deploy simple RWA"
echo "   npm run setup-reference   # Setup basic KYC policy"
echo ""
echo "🎉 Ready to build institutional RWA with 14-rule compliance!"
