// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {InstitutionalRWA} from "../src/InstitutionalRWA.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployInstitutionalRWA is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIV_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        // Mock USDC address for testing
        address mockUSDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
        vm.startBroadcast();
        new InstitutionalRWA(
            "Institutional RWA Token",
            "IRWA",
            deployer,
            IERC20(mockUSDC),
            deployer // payment recipient
        );
        vm.stopBroadcast();
    }
}