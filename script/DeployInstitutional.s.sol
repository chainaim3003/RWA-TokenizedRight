// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Script.sol";
import "../src/InstitutionalComplianceMock.sol";
import "../src/InstitutionalRWA.sol";

/**
 * @title Deploy Institutional RWA System
 * @dev Deploys the complete institutional RWA system with mock compliance contracts
 */
contract DeployInstitutional is Script {
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIV_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("🏛️ Deploying Institutional RWA System");
        console.log("Deployer address:", deployer);
        console.log("Deployer balance:", deployer.balance);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the comprehensive mock compliance contract
        console.log("📋 Deploying Institutional Compliance Mock...");
        InstitutionalComplianceMock complianceMock = new InstitutionalComplianceMock();
        console.log("✅ Compliance Mock deployed at:", address(complianceMock));
        
        // For demo, we'll use a mock USDC token address
        // In production, this would be the real USDC/PYUSD contract address
        address mockUSDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913; // Base USDC for demo
        address paymentRecipient = deployer; // For demo, payments go to deployer
        address rulesEngineAddress = vm.envAddress("RULES_ENGINE_ADDRESS");
        
        // Deploy the main institutional RWA contract
        console.log("🏢 Deploying Institutional RWA Contract...");
        InstitutionalRWA institutionalRWA = new InstitutionalRWA(
            "Institutional RWA Token",
            "IRWA",
            deployer, // token admin
            IERC20(mockUSDC), // payment token
            paymentRecipient, // payment recipient
            rulesEngineAddress // Forte Rules Engine address
        );
        console.log("✅ Institutional RWA deployed at:", address(institutionalRWA));
        
        vm.stopBroadcast();
        
        // Display deployment summary
        console.log("\n🎯 Deployment Summary");
        console.log("======================");
        console.log("Compliance Mock:", address(complianceMock));
        console.log("Institutional RWA:", address(institutionalRWA));
        console.log("Rules Engine:", rulesEngineAddress);
        console.log("");
        console.log("📝 Next Steps:");
        console.log("1. Update policy file with deployed compliance mock address");
        console.log("2. Run: npx tsx sdk.ts setupPolicy policies/institutional-complete.json");
        console.log("3. Run: npx tsx sdk.ts injectModifiers");
        console.log("4. Run: npx tsx sdk.ts applyPolicy <policyId>", address(institutionalRWA));
        
        // Write deployment addresses to file for easy reference
        string memory deploymentInfo = string(abi.encodePacked(
            "COMPLIANCE_MOCK_ADDRESS=", vm.toString(address(complianceMock)), "\n",
            "INSTITUTIONAL_RWA_ADDRESS=", vm.toString(address(institutionalRWA)), "\n",
            "RULES_ENGINE_ADDRESS=", vm.toString(rulesEngineAddress), "\n"
        ));
        
        vm.writeFile("deployment.env", deploymentInfo);
        console.log("💾 Deployment addresses saved to deployment.env");
    }
}
