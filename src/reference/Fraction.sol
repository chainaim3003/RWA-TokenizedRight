// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "src/reference/FractionFRE.sol";

/**
 * @title Original Fraction Contract from rwa-demo
 * @dev Simple fractional RWA token - kept for reference and testing
 * @dev Shows basic Forte Rules Engine integration pattern
 */
contract Fraction is FractionFRE, ERC721, Ownable {
    uint256 immutable TOTAL_SUPPLY;
    uint256 private totalMinted;
    uint256 public mintPrice;
    string private baseUri;
    address public immutable paymentRecipient;

    IERC20 public immutable paymentToken;

    // Mapping to track when each token was last transferred
    mapping(uint256 => uint256) private lastTransferTimestamp;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 totalSupply,
        address tokenAdmin,
        IERC20 _paymentToken,
        uint256 _mintPrice,
        address _paymentRecipient,
        address freAddress
    ) ERC721(tokenName, tokenSymbol) Ownable(tokenAdmin) {
        TOTAL_SUPPLY = totalSupply;
        paymentToken = IERC20(_paymentToken);
        mintPrice = _mintPrice;
        paymentRecipient = _paymentRecipient;

        // preset rules engine stuff now
        setRulesEngineAddress(freAddress);
    }

    function mint(
        address recipient,
        uint256 quantity
    ) public checkRulesBeforemint(recipient, quantity) {
        require(quantity > 0, "Quantity must be greater than 0");
        require(totalMinted + quantity <= TOTAL_SUPPLY, "Exceeds total supply");

        uint256 totalCost = mintPrice * quantity;
        require(
            paymentToken.transferFrom(msg.sender, paymentRecipient, totalCost),
            "Payment failed"
        );

        for (uint256 i = 1; i < quantity; i++) {
            _safeMint(recipient, totalMinted + i);
        }
        totalMinted += quantity;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    /**
     * This hooks into the Forte Rules Engine to manage mint, transfer, burn
     */
    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        virtual
        override
        checkRulesBefore_update(to, tokenId)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
