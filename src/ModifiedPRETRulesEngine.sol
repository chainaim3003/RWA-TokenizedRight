// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Modified PRET Rules Engine Mock Contract (Hackathon Demo Version)
 * @dev All string/bytes32 parameters converted to uint256 for Forte compatibility
 *      Added state variables and setters for interactive demonstration
 */
contract ModifiedPRETRulesEngine {
    
    // State variables for demo
    mapping(address => uint256) private kycLevels;
    mapping(address => bool) private ofacSanctioned;
    mapping(address => mapping(address => bool)) private crossBorderSanctioned;
    
    // Events for demonstration
    event KYCLevelSet(address indexed user, uint256 level);
    event OFACStatusSet(address indexed user, bool sanctioned);
    event CrossBorderStatusSet(address indexed from, address indexed to, bool sanctioned);
    
    // Asset Type Constants
    uint256 public constant TREASURY = 1;
    uint256 public constant CORPORATE = 2; 
    uint256 public constant MUNICIPAL = 3;
    uint256 public constant COMMERCIAL = 4;
    uint256 public constant RESIDENTIAL = 5;
    uint256 public constant COMMODITY = 6;
    uint256 public constant EQUITY = 7;
    uint256 public constant BOND = 8;
    
    // Market Condition Constants
    uint256 public constant BULL = 1;
    uint256 public constant BEAR = 2;
    uint256 public constant STABLE = 3;
    uint256 public constant VOLATILE = 4;
    uint256 public constant CRISIS = 5;
    uint256 public constant RECOVERY = 6;
    
    // Country Codes (ISO 3166-1 numeric)
    uint256 public constant US = 840;
    uint256 public constant GB = 826;
    uint256 public constant DE = 276;
    uint256 public constant FR = 250;
    uint256 public constant JP = 392;
    uint256 public constant SG = 702;
    uint256 public constant CN = 156;  // China
    
    // Metadata Categories
    uint256 public constant FINANCIAL = 1;
    uint256 public constant LEGAL = 2;
    uint256 public constant COMPLIANCE = 3;
    uint256 public constant OPERATIONAL = 4;
    uint256 public constant TECHNICAL = 5;

    // ========================================
    // DEMO SETTER FUNCTIONS (For Testing)
    // ========================================
    
    /**
     * Set KYC level for demo purposes
     */
    function setKycLevel(address user, uint256 level) external {
        kycLevels[user] = level;
        emit KYCLevelSet(user, level);
    }
    
    /**
     * Set OFAC sanctioned status for demo purposes
     */
    function setOFACSanctioned(address user, bool sanctioned) external {
        ofacSanctioned[user] = sanctioned;
        emit OFACStatusSet(user, sanctioned);
    }
    
    /**
     * Set cross-border sanctioned status for demo purposes
     */
    function setCrossBorderSanctioned(address from, address to, bool sanctioned) external {
        crossBorderSanctioned[from][to] = sanctioned;
        emit CrossBorderStatusSet(from, to, sanctioned);
    }

    // ========================================
    // INSTITUTIONAL COMPLIANCE RULES
    // ========================================
    
    /**
     * RULE_01: Enhanced KYC Level Check
     */
    function getKycLevel(address user) external view returns (uint256) {
        uint256 level = kycLevels[user];
        return level == 0 ? 3 : level; // Default to level 3 if not set
    }
    
    /**
     * RULE_02: OFAC Sanctions Check
     */
    function isOFACSanctioned(address user) external view returns (bool) {
        return ofacSanctioned[user];
    }
    
    /**
     * RULE_03: Cross-Border Sanctions Check
     */
    function isCrossBorderSanctioned(address from, address to) external view returns (bool) {
        return crossBorderSanctioned[from][to];
    }
    
    /**
     * RULE_13: PYUSD Peg Stability Check
     */
    function checkPYUSDPegStability(uint256 priceData) external pure returns (bool) {
        // Mock implementation - check if price is within 1% of $1.00
        uint256 target = 1000000; // $1.00 with 6 decimals
        uint256 tolerance = 10000; // 1% tolerance
        return (priceData >= target - tolerance && priceData <= target + tolerance);
    }

    // ========================================
    // CONVERTED RULES (String → uint256)
    // ========================================
    
    /**
     * RULE_04: GLEIF Entity Verification (CONVERTED)
     */
    function verifyGLEIF(uint256 leiHash, uint256 corporateNameHash) external pure returns (bool) {
        return leiHash != 0 && corporateNameHash != 0;
    }
    
    /**
     * RULE_05: BPMN Process Compliance (CONVERTED)
     */
    function verifyBPMNCompliance(uint256 processIdHash) external pure returns (uint256) {
        return processIdHash % 100; // Compliance score 0-100
    }
    
    /**
     * RULE_06: ACTUS Risk Score
     */
    function getACTUSRiskScore(uint256 contractId, uint256 riskProfileId) external pure returns (uint256) {
        return (contractId + riskProfileId) % 100;
    }
    
    /**
     * RULE_07: DCSA Document Verification (CONVERTED)
     */
    function verifyDCSADocuments(uint256 documentHashUint) external pure returns (bool) {
        return documentHashUint != 0;
    }
    
    /**
     * RULE_08: Optimal Fractions Calculation
     */
    function calculateOptimalFractions(uint256 totalValue, uint256 strategyId) external pure returns (uint256) {
        return totalValue / (strategyId + 1);
    }
    
    /**
     * RULE_09: Metadata Score (CONVERTED)
     */
    function getMetadataScore(uint256 tokenId, uint256 metadataUriHash, uint256 categoryId) external pure returns (uint256) {
        return (tokenId + metadataUriHash + categoryId) % 100;
    }
    
    /**
     * RULE_10: Minimum Fraction Threshold (CONVERTED)
     */
    function getMinimumFractionThreshold(uint256 assetTypeId) external pure returns (uint256) {
        if (assetTypeId == TREASURY) return 1000;
        if (assetTypeId == CORPORATE) return 5000;
        if (assetTypeId == MUNICIPAL) return 2500;
        return 10000;
    }
    
    /**
     * RULE_11: Liquidity Score (CONVERTED)
     */
    function getLiquidityScore(uint256 amount, uint256 marketConditionId) external pure returns (uint256) {
        uint256 baseScore = amount / 1000;
        
        if (marketConditionId == BULL) return baseScore * 120 / 100;
        if (marketConditionId == BEAR) return baseScore * 80 / 100;
        if (marketConditionId == VOLATILE) return baseScore * 90 / 100;
        return baseScore;
    }
    
    /**
     * RULE_12: Asset Type Threshold (CONVERTED)
     */
    function getAssetTypeThreshold(uint256 assetTypeId, uint256 amount) external pure returns (uint256) {
        if (assetTypeId == TREASURY) return amount * 95 / 100;
        if (assetTypeId == CORPORATE) return amount * 85 / 100;
        if (assetTypeId == MUNICIPAL) return amount * 90 / 100;
        return amount * 80 / 100;
    }
    
    /**
     * RULE_14: Cross-Border PYUSD Validation (CONVERTED)
     */
    function validateCrossBorderPYUSD(uint256 fromCountryCode, uint256 toCountryCode, uint256 amount) external pure returns (bool) {
        // Block sanctioned countries
        if (fromCountryCode == 643 || toCountryCode == 643) return false; // Russia
        if (fromCountryCode == 408 || toCountryCode == 408) return false; // North Korea
        
        // Amount limits
        if ((fromCountryCode == US && toCountryCode == CN) || (fromCountryCode == CN && toCountryCode == US)) {
            return amount <= 50000 * 10**6; // $50k limit for US-China
        }
        
        return amount <= 100000 * 10**6; // $100k general limit
    }
    
    // ========================================
    // HELPER FUNCTIONS
    // ========================================
    
    function bytes32ToUint256(bytes32 value) external pure returns (uint256) {
        return uint256(value);
    }
    
    function getAssetTypeName(uint256 assetTypeId) external pure returns (string memory) {
        if (assetTypeId == TREASURY) return "TREASURY";
        if (assetTypeId == CORPORATE) return "CORPORATE";
        if (assetTypeId == MUNICIPAL) return "MUNICIPAL";
        return "UNKNOWN";
    }
    
    function getMarketConditionName(uint256 conditionId) external pure returns (string memory) {
        if (conditionId == BULL) return "BULL";
        if (conditionId == BEAR) return "BEAR";
        if (conditionId == STABLE) return "STABLE";
        return "UNKNOWN";
    }
    
    // ========================================
    // DEMO INFO FUNCTIONS
    // ========================================
    
    function getTotalRulesCount() external pure returns (uint256) {
        return 14; // All 14 institutional rules implemented
    }
    
    function getContractInfo() external pure returns (string memory) {
        return "Modified PRET Rules Engine - 14 Institutional Compliance Rules - Forte Compatible";
    }
}
