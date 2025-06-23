// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "src/InstitutionalRWAFRE.sol";

/**
 * @title Institutional RWA Contract
 * @dev ERC721 contract for institutional real-world assets with comprehensive 14-rule compliance
 * @dev Protected by Forte Rules Engine with all ZK PRET integrations
 */
contract InstitutionalRWA is InstitutionalRWAFRE, ERC721, Ownable {
    
    // Asset metadata structure
    struct AssetMetadata {
        uint256 principalAmount;
        string assetType;
        string legalEntityIdentifier;
        string corporateName;
        bytes32 documentHash;
        uint256 mintTimestamp;
        string buyerCountry;
        string sellerCountry;
        uint256 pyusdAmount;
    }
    
    // Token supply tracking
    uint256 public totalSupply;
    uint256 public constant MAX_SUPPLY = 100000;
    
    // Payment token (USDC/PYUSD)
    IERC20 public immutable paymentToken;
    address public immutable paymentRecipient;
    
    // Asset metadata mapping
    mapping(uint256 => AssetMetadata) public assetMetadata;
    
    // Events
    event InstitutionalAssetMinted(
        uint256 indexed tokenId,
        address indexed recipient,
        uint256 principalAmount,
        string assetType,
        string lei
    );
    
    event PYUSDAssetMinted(
        uint256 indexed tokenId,
        address indexed recipient,
        uint256 pyusdAmount,
        string buyerCountry,
        string sellerCountry
    );
    
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        address tokenAdmin,
        IERC20 _paymentToken,
        address _paymentRecipient,
        address freAddress
    ) ERC721(tokenName, tokenSymbol) Ownable(tokenAdmin) {
        paymentToken = _paymentToken;
        paymentRecipient = _paymentRecipient;
        
        // Initialize Forte Rules Engine integration
        setRulesEngineAddress(freAddress);
    }
    
    /**
     * @dev Mint institutional RWA with comprehensive 14-rule compliance
     * @dev This function is protected by ALL institutional compliance rules (RULE_01 through RULE_12)
     */
    function mintInstitutionalAsset(
        address recipient,
        uint256 amount,
        uint256 principalAmount,
        string memory assetType,
        string memory lei,
        string memory corporateName
    ) 
        external 
        checkRulesBeforemintInstitutionalAsset(recipient, amount, principalAmount, assetType, lei, corporateName)
    {
        require(totalSupply < MAX_SUPPLY, "Maximum supply reached");
        require(principalAmount > 0, "Principal amount must be greater than 0");
        require(bytes(assetType).length > 0, "Asset type required");
        require(bytes(lei).length == 20, "Valid 20-character LEI required");
        
        // Calculate payment amount based on principal amount (1:1000 ratio for demo)
        uint256 paymentAmount = principalAmount / 1000;
        require(
            paymentToken.transferFrom(msg.sender, paymentRecipient, paymentAmount),
            "Payment failed"
        );
        
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        
        // Store comprehensive asset metadata
        assetMetadata[tokenId] = AssetMetadata({
            principalAmount: principalAmount,
            assetType: assetType,
            legalEntityIdentifier: lei,
            corporateName: corporateName,
            documentHash: keccak256(abi.encodePacked(lei, corporateName, block.timestamp)),
            mintTimestamp: block.timestamp,
            buyerCountry: "",
            sellerCountry: "",
            pyusdAmount: 0
        });
        
        _safeMint(recipient, tokenId);
        
        emit InstitutionalAssetMinted(tokenId, recipient, principalAmount, assetType, lei);
    }
    
    /**
     * @dev Mint PYUSD-denominated RWA with cross-border compliance
     * @dev This function is protected by PYUSD-specific rules (RULE_13 and RULE_14)
     */
    function mintInstitutionalAssetPYUSD(
        address recipient,
        uint256 amount,
        uint256 pyusdAmount,
        string memory buyerCountry,
        string memory sellerCountry
    )
        external
        checkRulesBeforemintInstitutionalAssetPYUSD(recipient, amount, pyusdAmount, buyerCountry, sellerCountry)
    {
        require(totalSupply < MAX_SUPPLY, "Maximum supply reached");
        require(pyusdAmount >= 1000000, "Minimum $1M for institutional PYUSD trades");
        require(bytes(buyerCountry).length > 0, "Buyer country required");
        require(bytes(sellerCountry).length > 0, "Seller country required");
        
        // PYUSD payment processing
        require(
            paymentToken.transferFrom(msg.sender, paymentRecipient, pyusdAmount),
            "PYUSD payment failed"
        );
        
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        
        // Store PYUSD-specific metadata
        assetMetadata[tokenId] = AssetMetadata({
            principalAmount: pyusdAmount,
            assetType: "PYUSD_CROSS_BORDER",
            legalEntityIdentifier: "",
            corporateName: "",
            documentHash: keccak256(abi.encodePacked(buyerCountry, sellerCountry, block.timestamp)),
            mintTimestamp: block.timestamp,
            buyerCountry: buyerCountry,
            sellerCountry: sellerCountry,
            pyusdAmount: pyusdAmount
        });
        
        _safeMint(recipient, tokenId);
        
        emit PYUSDAssetMinted(tokenId, recipient, pyusdAmount, buyerCountry, sellerCountry);
    }
    
    /**
     * @dev Transfer function with existing rwa-demo compliance (KYC + OFAC)
     * @dev This hooks into the Forte Rules Engine for transfer compliance
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
    
    // View functions for asset metadata
    function getAssetMetadata(uint256 tokenId) external view returns (AssetMetadata memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return assetMetadata[tokenId];
    }
    
    function getAssetPrincipalAmount(uint256 tokenId) external view returns (uint256) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return assetMetadata[tokenId].principalAmount;
    }
    
    function getAssetType(uint256 tokenId) external view returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return assetMetadata[tokenId].assetType;
    }
    
    function getLEI(uint256 tokenId) external view returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return assetMetadata[tokenId].legalEntityIdentifier;
    }
    
    // Admin functions
    function updatePaymentRecipient(address newRecipient) external onlyOwner {
        // This would need additional validation in production
        require(newRecipient != address(0), "Invalid recipient");
    }
    
    function emergencyPause() external onlyOwner {
        // Emergency pause functionality would be implemented here
        // Connected to the emergency controls in the policy
    }
    
    // Function to support interface detection
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
