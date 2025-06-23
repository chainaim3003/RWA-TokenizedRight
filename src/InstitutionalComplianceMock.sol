// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title Institutional Compliance Mock Contract
 * @dev Comprehensive mock implementation for all 14 institutional RWA compliance rules
 * @dev Includes ZK PRET mock capabilities (GLEIF, BPMN, ACTUS, DCSA) and PYUSD compliance
 */
contract InstitutionalComplianceMock {
    
    // Mapping for KYC levels (address => level)
    mapping(address => uint256) public kycLevels;
    
    // Mapping for OFAC sanctions (address => isSanctioned)
    mapping(address => bool) public ofacSanctions;
    
    // Mapping for cross-border sanctions (sender => recipient => isSanctioned)
    mapping(address => mapping(address => bool)) public crossBorderSanctions;
    
    // Mock LEI database (LEI => corporateName => isValid)
    mapping(string => mapping(string => bool)) public gleifDatabase;
    
    // Asset type minimum thresholds
    mapping(string => uint256) public assetTypeThresholds;
    
    // Country pair compliance for PYUSD
    mapping(string => mapping(string => bool)) public countryCompliance;
    
    // Mock PYUSD peg price (scaled by 1000, so 1000 = $1.00)
    uint256 public pyusdPegPrice = 1001; // $1.001
    
    constructor() {
        // Setup initial KYC levels for testing
        kycLevels[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 4; // High KYC
        kycLevels[0x3C44CdDdB6a900fa2b585dd299e07d12A1F38Fa9] = 2; // Low KYC (will fail)
        kycLevels[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 5; // Very high KYC
        
        // Setup OFAC sanctions for testing
        ofacSanctions[0x1111111111111111111111111111111111111111] = true; // Sanctioned
        ofacSanctions[0x2222222222222222222222222222222222222222] = true; // Sanctioned
        
        // Setup GLEIF database for testing
        gleifDatabase["HWUPKR0MPOU8FGXBT394"]["APPLE INC"] = true;
        gleifDatabase["5493000IBP32UQZ0KL24"]["TESLA INC"] = true;
        gleifDatabase["254900OPPU84GM83MG36"]["MICROSOFT CORPORATION"] = true;
        gleifDatabase["INVALIDLEI123456789"]["INVALID CORP"] = false;
        
        // Setup asset type thresholds
        assetTypeThresholds["SUPPLY_CHAIN_INVOICE"] = 70;
        assetTypeThresholds["EQUIPMENT_FINANCE"] = 85;
        assetTypeThresholds["TRADE_FINANCE"] = 80;
        assetTypeThresholds["WORKING_CAPITAL"] = 75;
        assetTypeThresholds["COMMERCIAL_REAL_ESTATE"] = 90;
        assetTypeThresholds["CORPORATE_BONDS"] = 85;
        assetTypeThresholds["STRUCTURED_PRODUCTS"] = 95;
        
        // Setup country compliance for PYUSD testing
        countryCompliance["US"]["GB"] = true;
        countryCompliance["US"]["DE"] = true;
        countryCompliance["US"]["IN"] = true;
        countryCompliance["US"]["JP"] = true;
        countryCompliance["GB"]["DE"] = true;
        countryCompliance["IR"]["US"] = false; // Iran restricted
        countryCompliance["KP"]["US"] = false; // North Korea restricted
    }
    
    // RULE 01 & Basic KYC: Get KYC level for address
    function getKycLevel(address user) external view returns (uint256) {
        return kycLevels[user];
    }
    
    // RULE 02: Check OFAC sanctions
    function isOFACSanctioned(address user) external view returns (bool) {
        return ofacSanctions[user];
    }
    
    // RULE 03: Check cross-border sanctions
    function isCrossBorderSanctioned(address sender, address recipient) external view returns (bool) {
        return crossBorderSanctions[sender][recipient];
    }
    
    // RULE 04: ZK PRET GLEIF Verification
    function verifyGLEIF(string memory lei, string memory corporateName) external view returns (bool) {
        return gleifDatabase[lei][corporateName];
    }
    
    // RULE 05: ZK PRET BPMN Business Process Compliance
    function verifyBPMNCompliance(string memory assetDescription) external pure returns (uint256) {
        // Mock BPMN scoring based on asset description length and content
        bytes memory desc = bytes(assetDescription);
        if (desc.length < 10) return 40; // Too short
        if (desc.length >= 50) return 90; // Comprehensive description
        return 70; // Standard description
    }
    
    // RULE 06: ZK PRET ACTUS Risk Assessment
    function getACTUSRiskScore(uint256 principalAmount, string memory assetType) external pure returns (uint256) {
        // Mock ACTUS risk scoring
        uint256 baseRisk = 200;
        
        // Higher amounts = higher risk
        if (principalAmount > 10000000) baseRisk += 200; // > $10M
        else if (principalAmount > 5000000) baseRisk += 100; // > $5M
        else if (principalAmount > 1000000) baseRisk += 50;  // > $1M
        
        // Asset type risk adjustment
        if (keccak256(bytes(assetType)) == keccak256(bytes("STRUCTURED_PRODUCTS"))) {
            baseRisk += 200; // High risk asset type
        } else if (keccak256(bytes(assetType)) == keccak256(bytes("COMMERCIAL_REAL_ESTATE"))) {
            baseRisk += 100; // Medium risk
        }
        
        return baseRisk;
    }
    
    // RULE 07: ZK PRET DCSA Trade Document Verification
    function verifyDCSADocuments(bytes32 documentHash) external pure returns (bool) {
        // Mock DCSA verification - accept any non-zero hash
        return documentHash != bytes32(0);
    }
    
    // RULE 08: Optimal Fraction Calculation
    function calculateOptimalFractions(uint256 principalAmount, string memory assetType) external pure returns (uint256) {
        // Mock optimal fraction calculation
        uint256 baseCount = principalAmount / 1000; // $1000 per fraction as base
        
        // Asset type adjustments
        if (keccak256(bytes(assetType)) == keccak256(bytes("COMMERCIAL_REAL_ESTATE"))) {
            baseCount = principalAmount / 25000; // Larger fractions for real estate
        } else if (keccak256(bytes(assetType)) == keccak256(bytes("SUPPLY_CHAIN_INVOICE"))) {
            baseCount = principalAmount / 1000; // Standard fractions
        }
        
        // Ensure within bounds
        if (baseCount < 10) return 10;
        if (baseCount > 10000) return 10000;
        return baseCount;
    }
    
    // RULE 09: Metadata Completeness Score
    function getMetadataScore(uint256 principalAmount, string memory assetType, string memory lei) external pure returns (uint256) {
        uint256 score = 40; // Base score
        
        // LEI component (up to 20 points)
        if (bytes(lei).length == 20) score += 20;
        else if (bytes(lei).length > 0) score += 10;
        
        // Asset type component (up to 15 points)
        if (bytes(assetType).length > 0) score += 15;
        
        // Principal amount component (up to 25 points)
        if (principalAmount > 1000000) score += 25; // > $1M
        else if (principalAmount > 100000) score += 15; // > $100K
        else if (principalAmount > 0) score += 10;
        
        return score > 100 ? 100 : score;
    }
    
    // RULE 10: Minimum Fraction Threshold
    function getMinimumFractionThreshold(string memory assetType) external view returns (uint256) {
        uint256 threshold = assetTypeThresholds[assetType];
        return threshold > 0 ? threshold * 10 : 500; // Default $500 minimum, scaled by asset type
    }
    
    // RULE 11: Liquidity Score
    function getLiquidityScore(uint256 totalFractions, string memory assetType) external pure returns (uint256) {
        // Mock liquidity scoring
        uint256 score = 50; // Base score
        
        // Fraction count component
        if (totalFractions >= 100 && totalFractions <= 5000) {
            score += 50; // Optimal range
        } else if (totalFractions >= 50) {
            score += 30; // Acceptable range
        }
        
        // Asset type liquidity bonus
        if (keccak256(bytes(assetType)) == keccak256(bytes("SUPPLY_CHAIN_INVOICE"))) {
            score += 20; // High liquidity asset
        }
        
        return score > 100 ? 100 : score;
    }
    
    // RULE 12: Asset-Specific Metadata Threshold
    function getAssetTypeThreshold(string memory assetType, uint256 principalAmount) external view returns (uint256) {
        uint256 baseThreshold = assetTypeThresholds[assetType];
        if (baseThreshold == 0) baseThreshold = 70; // Default
        
        // Higher amounts require higher thresholds
        if (principalAmount > 10000000) baseThreshold += 10; // > $10M
        else if (principalAmount > 5000000) baseThreshold += 5;  // > $5M
        
        return baseThreshold > 100 ? 100 : baseThreshold;
    }
    
    // RULE 13: PYUSD Peg Stability Check
    function checkPYUSDPegStability(uint256 pyusdAmount) external view returns (bool) {
        // Check if peg is stable (between $0.995 and $1.005)
        bool pegStable = pyusdPegPrice >= 995 && pyusdPegPrice <= 1005;
        
        // Check liquidity constraints
        bool sufficientLiquidity = pyusdAmount <= 50000000; // $50M max
        bool meetsMininumInstitutional = pyusdAmount >= 1000000; // $1M min
        
        return pegStable && sufficientLiquidity && meetsMininumInstitutional;
    }
    
    // RULE 14: Cross-Border PYUSD Validation
    function validateCrossBorderPYUSD(string memory buyerCountry, string memory sellerCountry, uint256 pyusdAmount) external view returns (bool) {
        // Check if country pair is compliant
        bool countriesCompliant = countryCompliance[buyerCountry][sellerCountry] || 
                                 countryCompliance[sellerCountry][buyerCountry];
        
        // Check amount limits (varies by country pair)
        uint256 maxAmount = 25000000; // Default $25M
        if (keccak256(bytes(buyerCountry)) == keccak256(bytes("US")) || 
            keccak256(bytes(sellerCountry)) == keccak256(bytes("US"))) {
            maxAmount = 100000000; // $100M for US pairs
        }
        
        bool withinLimits = pyusdAmount <= maxAmount;
        
        return countriesCompliant && withinLimits;
    }
    
    // Admin functions for testing different scenarios
    function setKycLevel(address user, uint256 level) external {
        kycLevels[user] = level;
    }
    
    function setOFACSanction(address user, bool isSanctioned) external {
        ofacSanctions[user] = isSanctioned;
    }
    
    function setPYUSDPegPrice(uint256 newPrice) external {
        pyusdPegPrice = newPrice;
    }
    
    function setCountryCompliance(string memory country1, string memory country2, bool isCompliant) external {
        countryCompliance[country1][country2] = isCompliant;
    }
    
    function addGLEIFEntry(string memory lei, string memory corporateName, bool isValid) external {
        gleifDatabase[lei][corporateName] = isValid;
    }
}
