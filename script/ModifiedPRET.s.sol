// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {ModifiedPRETRulesEngine} from "../src/ModifiedPRETRulesEngine.sol";

contract DeployModifiedPRET is Script {
    function run() external {
        vm.startBroadcast();
        new ModifiedPRETRulesEngine();
        vm.stopBroadcast();
    }
}