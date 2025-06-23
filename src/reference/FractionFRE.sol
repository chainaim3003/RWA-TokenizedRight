import "@thrackle-io/forte-rules-engine/src/client/RulesEngineClient.sol";

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

/**
 * @title Original FractionFRE from rwa-demo
 * @author @mpetersoCode55, @ShaneDuncan602, @TJ-Everett, @VoR0220
 * @dev Simple Forte Rules Engine integration - kept for reference
 * @dev Shows basic modifier pattern for simple RWA compliance
 */
abstract contract FractionFRE is RulesEngineClient {
    modifier checkRulesBeforemint(address recipient, uint256 quantity) {
        bytes memory encoded = abi.encodeWithSelector(
            msg.sig,
            recipient,
            quantity
        );
        _invokeRulesEngine(encoded);
        _;
    }

    modifier checkRulesBefore_update(address to, uint256 tokenId) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, to, tokenId);
        _invokeRulesEngine(encoded);
        _;
    }

    modifier checkRulesAfter_update(address to, uint256 tokenId) {
        bytes memory encoded = abi.encodeWithSelector(msg.sig, to, tokenId);
        _;
        _invokeRulesEngine(encoded);
    }
}
