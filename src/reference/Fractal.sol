// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "src/reference/FractalFRE.sol";

/**
 * @title Fractal ERC20 Token from rwa-demo
 * @dev Simple ERC20 token with Forte Rules Engine integration - kept for reference
 */
contract Fractal is RulesEngineClientCustom, ERC20 {
    uint256 constant TOTAL_SUPPLY = 21_000_000 * 1e18;

    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20(tokenName, tokenSymbol) {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override checkRulesBefore_update(from, to, value) {
        super._update(from, to, value);
    }
}
