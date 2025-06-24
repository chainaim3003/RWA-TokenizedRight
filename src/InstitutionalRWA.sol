// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "src/InstitutionalRWAFRE.sol";

/**
 * @title Institutional RWA Contract - Forte Compatible (Following rwa_demo patterns)
 * @dev ERC721 contract for institutional real-world assets with comprehensive 14-rule compliance
 * @dev Protected by Forte Rules Engine with converted uint256 parameters
 */
contract InstitutionalRWA is InstitutionalRWAFRE, ERC721, Ownable {
    
    // Asset metadata structure (stores original strings for metadata)
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
        uint256 assetTypeId,
        uint256 leiHash
    );
    
    event PYUSDAssetMinted(
        uint256 indexed tokenId,
        address indexed recipient,
        uint256 pyusdAmount,
        uint256 fromCountryCode,
        uint256 toCountryCode
    );
    
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        address tokenAdmin,
        IERC20 _paymentToken,
        address _paymentRecipient
    ) ERC721(tokenName, tokenSymbol) Ownable(tokenAdmin) {
        paymentToken = _paymentToken;
        paymentRecipient = _paymentRecipient;
    }
    
    /**
     * @dev Mint institutional RWA with comprehensive 14-rule compliance
     * @dev Uses converted uint256 parameters for Forte Rules Engine compatibility
     * @param recipient Address receiving the asset
     * @param amount Number of fractions being minted
     * @param principalAmount USD value of the underlying asset
     * @param assetTypeId Asset type as uint256 (1=TREASURY, 2=CORPORATE, etc.)
     * @param leiHash Keccak256 hash of LEI code
     * @param corporateNameHash Keccak256 hash of corporate name
     * @param assetType Original asset type string (for metadata)
     * @param lei Original LEI string (for metadata)
     * @param corporateName Original corporate name (for metadata)
     */
    function mintInstitutionalAsset(
        address recipient,
        uint256 amount,
        uint256 principalAmount,
        uint256 assetTypeId,
        uint256 leiHash,
        uint256 corporateNameHash,
        string memory assetType,
        string memory lei,
        string memory corporateName
    ) 
        external 
        checkRulesBeforemintInstitutionalAsset(recipient, amount, principalAmount, assetTypeId, leiHash, corporateNameHash)
    {
        require(totalSupply < MAX_SUPPLY, "Maximum supply reached");
        require(principalAmount > 0, "Principal amount must be greater than 0");
        require(assetTypeId > 0, "Valid asset type ID required");
        require(leiHash != 0, "Valid LEI hash required");
        require(corporateNameHash != 0, "Valid corporate name hash required");
        
        // Skip payment for demo (comment back in for production)
        // uint256 paymentAmount = principalAmount / 1000;
        // require(
        //     paymentToken.transferFrom(msg.sender, paymentRecipient, paymentAmount),
        //     "Payment failed"
        // );
        
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        
        // Store comprehensive asset metadata
        assetMetadata[tokenId] = AssetMetadata({
            principalAmount: principalAmount,
            assetType: assetType,
            legalEntityIdentifier: lei,
            corporateName: corporateName,
            documentHash: keccak256(abi.encodePacked(leiHash, corporateNameHash, block.timestamp)),
            mintTimestamp: block.timestamp,
            buyerCountry: "",
            sellerCountry: "",
            pyusdAmount: 0
        });
        
        _safeMint(recipient, tokenId);
        
        emit InstitutionalAssetMinted(tokenId, recipient, principalAmount, assetTypeId, leiHash);
    }
    
    /**
     * @dev Mint PYUSD-denominated RWA with cross-border compliance
     * @dev Uses converted uint256 parameters for Forte Rules Engine compatibility
     * @param recipient Address receiving the PYUSD-denominated asset
     * @param amount Number of fractions being minted
     * @param pyusdAmount PYUSD amount for the transaction
     * @param fromCountryCode ISO 3166-1 numeric country code for buyer
     * @param toCountryCode ISO 3166-1 numeric country code for seller
     * @param buyerCountry Original buyer country string (for metadata)
     * @param sellerCountry Original seller country string (for metadata)
     */
    function mintInstitutionalAssetPYUSD(
        address recipient,
        uint256 amount,
        uint256 pyusdAmount,
        uint256 fromCountryCode,
        uint256 toCountryCode,
        string memory buyerCountry,
        string memory sellerCountry
    )
        external
        checkRulesBeforemintInstitutionalAssetPYUSD(recipient, amount, pyusdAmount, fromCountryCode, toCountryCode)
    {
        require(totalSupply < MAX_SUPPLY, "Maximum supply reached");
        require(pyusdAmount >= 1000000, "Minimum $1 for institutional PYUSD trades");
        require(fromCountryCode > 0, "Valid from country code required");
        require(toCountryCode > 0, "Valid to country code required");
        
        // Skip payment for demo (comment back in for production)
        // require(
        //     paymentToken.transferFrom(msg.sender, paymentRecipient, pyusdAmount),
        //     "PYUSD payment failed"
        // );
        
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        
        // Store PYUSD-specific metadata
        assetMetadata[tokenId] = AssetMetadata({
            principalAmount: pyusdAmount,
            assetType: "PYUSD_CROSS_BORDER",
            legalEntityIdentifier: "",
            corporateName: "",
            documentHash: keccak256(abi.encodePacked(fromCountryCode, toCountryCode, block.timestamp)),
            mintTimestamp: block.timestamp,
            buyerCountry: buyerCountry,
            sellerCountry: sellerCountry,
            pyusdAmount: pyusdAmount
        });
        
        _safeMint(recipient, tokenId);
        
        emit PYUSDAssetMinted(tokenId, recipient, pyusdAmount, fromCountryCode, toCountryCode);
    }
    
    /**
     * @dev Transfer function with Forte Rules Engine compliance (following rwa_demo pattern)
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
        require(newRecipient != address(0), "Invalid recipient");
    }
    
    function emergencyPause() external onlyOwner {
        // Emergency pause functionality would be implemented here
    }
    
    // Function to support interface detection
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}