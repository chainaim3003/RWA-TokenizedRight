const { ethers, BigNumber } = require('ethers');

// Asset Type Constants
export const ASSET_TYPES = {
  "TREASURY": 1,
  "CORPORATE": 2,
  "MUNICIPAL": 3,
  "COMMERCIAL": 4,
  "RESIDENTIAL": 5,
  "COMMODITY": 6,
  "EQUITY": 7,
  "BOND": 8
} as const;

// Market Condition Constants  
export const MARKET_CONDITIONS = {
  "BULL": 1,
  "BEAR": 2,
  "STABLE": 3,
  "VOLATILE": 4,
  "CRISIS": 5,
  "RECOVERY": 6
} as const;

// ISO 3166-1 Country Codes (numeric)
export const COUNTRY_CODES = {
  "US": 840,
  "GB": 826, 
  "DE": 276,
  "FR": 250,
  "JP": 392,
  "SG": 702,
  "HK": 344,
  "AU": 36,
  "CA": 124,
  "CH": 756
} as const;

// Metadata Category Constants
export const METADATA_CATEGORIES = {
  "FINANCIAL": 1,
  "LEGAL": 2,
  "COMPLIANCE": 3,
  "OPERATIONAL": 4,
  "TECHNICAL": 5
} as const;

/**
 * Convert string to uint256 hash
 */
export function stringToUint256Hash(input: string): string {
  const hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(input));
  return BigNumber.from(hash).toString();
}

/**
 * Convert bytes32 to uint256
 */
export function bytes32ToUint256(bytes32Value: string): string {
  return BigNumber.from(bytes32Value).toString();
}

/**
 * Get asset type ID from string
 */
export function getAssetTypeId(assetType: string): number {
  const upperType = assetType.toUpperCase() as keyof typeof ASSET_TYPES;
  const id = ASSET_TYPES[upperType];
  if (!id) {
    throw new Error(`Unknown asset type: ${assetType}`);
  }
  return id;
}

/**
 * Get market condition ID from string
 */
export function getMarketConditionId(condition: string): number {
  const upperCondition = condition.toUpperCase() as keyof typeof MARKET_CONDITIONS;
  const id = MARKET_CONDITIONS[upperCondition];
  if (!id) {
    throw new Error(`Unknown market condition: ${condition}`);
  }
  return id;
}

/**
 * Get country code from string
 */
export function getCountryCode(country: string): number {
  const upperCountry = country.toUpperCase() as keyof typeof COUNTRY_CODES;
  const code = COUNTRY_CODES[upperCountry];
  if (!code) {
    throw new Error(`Unknown country code: ${country}`);
  }
  return code;
}

/**
 * Get metadata category ID from string
 */
export function getMetadataCategoryId(category: string): number {
  const upperCategory = category.toUpperCase() as keyof typeof METADATA_CATEGORIES;
  const id = METADATA_CATEGORIES[upperCategory];
  if (!id) {
    throw new Error(`Unknown metadata category: ${category}`);
  }
  return id;
}

// Example usage functions for each converted rule

/**
 * RULE_04: Convert GLEIF parameters
 */
export function convertGLEIFParams(lei: string, corporateName: string) {
  return {
    leiHash: stringToUint256Hash(lei),
    corporateNameHash: stringToUint256Hash(corporateName)
  };
}

/**
 * RULE_05: Convert BPMN parameters  
 */
export function convertBPMNParams(processId: string) {
  return {
    processIdHash: stringToUint256Hash(processId)
  };
}

/**
 * RULE_07: Convert DCSA parameters
 */
export function convertDCSAParams(documentHash: string) {
  return {
    documentHashUint: bytes32ToUint256(documentHash)
  };
}

/**
 * RULE_09: Convert metadata score parameters
 */
export function convertMetadataScoreParams(tokenId: string, metadataUri: string, category: string) {
  return {
    tokenId: tokenId,
    metadataUriHash: stringToUint256Hash(metadataUri),
    categoryId: getMetadataCategoryId(category)
  };
}

/**
 * RULE_10: Convert fraction threshold parameters
 */
export function convertFractionThresholdParams(assetType: string) {
  return {
    assetTypeId: getAssetTypeId(assetType)
  };
}

/**
 * RULE_11: Convert liquidity score parameters
 */
export function convertLiquidityScoreParams(amount: string, marketCondition: string) {
  return {
    amount: amount,
    marketConditionId: getMarketConditionId(marketCondition)
  };
}

/**
 * RULE_12: Convert asset type threshold parameters
 */
export function convertAssetTypeThresholdParams(assetType: string, amount: string) {
  return {
    assetTypeId: getAssetTypeId(assetType),
    amount: amount
  };
}

/**
 * RULE_14: Convert cross-border PYUSD parameters
 */
export function convertCrossBorderPYUSDParams(fromCountry: string, toCountry: string, amount: string) {
  return {
    fromCountryCode: getCountryCode(fromCountry),
    toCountryCode: getCountryCode(toCountry),
    amount: amount
  };
}

// Helper function to convert all parameters for policy setup
export interface ConvertedRuleParams {
  [key: string]: string | number;
}

export function convertAllRuleParams(originalParams: any): ConvertedRuleParams {
  // This would be used when setting up policies with the Forte SDK
  // Convert based on the rule type and original parameters
  const converted: ConvertedRuleParams = {};
  
  for (const [key, value] of Object.entries(originalParams)) {
    if (typeof value === 'string') {
      // Check if it's a known mappable type
      if (Object.keys(ASSET_TYPES).includes(value.toUpperCase())) {
        converted[key] = getAssetTypeId(value);
      } else if (Object.keys(MARKET_CONDITIONS).includes(value.toUpperCase())) {
        converted[key] = getMarketConditionId(value);
      } else if (Object.keys(COUNTRY_CODES).includes(value.toUpperCase())) {
        converted[key] = getCountryCode(value);
      } else if (Object.keys(METADATA_CATEGORIES).includes(value.toUpperCase())) {
        converted[key] = getMetadataCategoryId(value);
      } else {
        // Default to hash for unknown strings
        converted[key] = stringToUint256Hash(value);
      }
    } else {
      // Keep non-string values as-is
      converted[key] = value;
    }
  }
  
  return converted;
}