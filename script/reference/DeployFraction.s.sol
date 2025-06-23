// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Fraction} from "../src/reference/Fraction.sol";

/**
 * @title Deploy Reference Fraction Contract
 * @dev Original deployment script from rwa-demo - kept for reference and learning
 */
contract DeployFraction is Script {
    function run() external {
        address owner = vm.envAddress("DEPLOYER");
        IERC20 fractalToken = IERC20(vm.envAddress("FRACTAL_TOKEN"));
        address freAddress = vm.envAddress("RULES_ENGINE_ADDRESS");

        console.log("📋 Deploying reference Fraction contract...");
        console.log("Owner:", owner);
        console.log("Rules Engine:", freAddress);

        vm.startBroadcast();
        
        Fraction fraction = new Fraction(
            "Reference RWA Token",
            "REFR",
            10000,
            owner,
            fractalToken,
            5000000000000000000, // 5 ETH per token
            owner,
            freAddress
        );
        
        vm.stopBroadcast();
        
        console.log("✅ Reference Fraction deployed at:", address(fraction));
        console.log("🎯 Use this for testing basic Forte functionality");
    }
}
