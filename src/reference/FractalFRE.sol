import "@thrackle-io/forte-rules-engine/src/client/RulesEngineClient.sol";

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

/**
 * @title FractalFRE from rwa-demo
 * @author @mpetersoCode55, @ShaneDuncan602, @TJ-Everett, @VoR0220
 * @dev Forte Rules Engine integration for ERC20 tokens - kept for reference
 */
abstract contract RulesEngineClientCustom is RulesEngineClient {
    modifier checkRulesBefore_update(
        address from,
        address to,
        uint256 value
    ) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, from, to, value);
        _invokeRulesEngine(encoded);
        _;
    }

    modifier checkRulesAfter_update(
        address from,
        address to,
        uint256 value
    ) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, from, to, value);
        _;
        _invokeRulesEngine(encoded);
    }
}
