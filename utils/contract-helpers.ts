import { 
  convertGLEIFParams,
  convertCrossBorderPYUSDParams,
  getAssetTypeId,
  getCountryCode,
  ASSET_TYPES,
  COUNTRY_CODES 
} from './utils/conversion-utilities';

/**
 * Helper functions to convert user inputs for InstitutionalRWA contract calls
 */

/**
 * Convert parameters for mintInstitutionalAsset function
 */
export function convertMintInstitutionalAssetParams(
  recipient: string,
  amount: string,
  principalAmount: string,
  assetType: string,
  lei: string,
  corporateName: string
) {
  const { leiHash, corporateNameHash } = convertGLEIFParams(lei, corporateName);
  const assetTypeId = getAssetTypeId(assetType);
  
  return {
    // Forte-compatible parameters (uint256)
    recipient,
    amount,
    principalAmount,
    assetTypeId,
    leiHash,
    corporateNameHash,
    // Original parameters (for metadata)
    assetType,
    lei,
    corporateName
  };
}

/**
 * Convert parameters for mintInstitutionalAssetPYUSD function
 */
export function convertMintPYUSDAssetParams(
  recipient: string,
  amount: string,
  pyusdAmount: string,
  buyerCountry: string,
  sellerCountry: string
) {
  const fromCountryCode = getCountryCode(buyerCountry);
  const toCountryCode = getCountryCode(sellerCountry);
  
  return {
    // Forte-compatible parameters (uint256)
    recipient,
    amount,
    pyusdAmount,
    fromCountryCode,
    toCountryCode,
    // Original parameters (for metadata)
    buyerCountry,
    sellerCountry
  };
}

/**
 * Example usage demonstration
 */
export function demonstrateUsage() {
  console.log("🎯 InstitutionalRWA Function Parameter Conversion Examples");
  console.log("========================================================");
  
  // Example 1: Mint Institutional Asset
  console.log("\n1️⃣ Mint Institutional Asset:");
  const institutionalParams = convertMintInstitutionalAssetParams(
    "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
    "100",
    "5000000",
    "TREASURY",
    "HWUPKR0MPOU8FGXBT394",
    "Apple Inc"
  );
  console.log("Converted params:", institutionalParams);
  console.log("Call function with:");
  console.log(`  mintInstitutionalAsset(
    "${institutionalParams.recipient}",
    ${institutionalParams.amount},
    ${institutionalParams.principalAmount},
    ${institutionalParams.assetTypeId},
    "${institutionalParams.leiHash}",
    "${institutionalParams.corporateNameHash}",
    "${institutionalParams.assetType}",
    "${institutionalParams.lei}",
    "${institutionalParams.corporateName}"
  )`);
  
  // Example 2: Mint PYUSD Asset
  console.log("\n2️⃣ Mint PYUSD Asset:");
  const pyusdParams = convertMintPYUSDAssetParams(
    "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
    "50",
    "1000000",
    "US",
    "GB"
  );
  console.log("Converted params:", pyusdParams);
  console.log("Call function with:");
  console.log(`  mintInstitutionalAssetPYUSD(
    "${pyusdParams.recipient}",
    ${pyusdParams.amount},
    ${pyusdParams.pyusdAmount},
    ${pyusdParams.fromCountryCode},
    ${pyusdParams.toCountryCode},
    "${pyusdParams.buyerCountry}",
    "${pyusdParams.sellerCountry}"
  )`);
  
  console.log("\n📋 Available Asset Types:", Object.keys(ASSET_TYPES));
  console.log("📋 Available Country Codes:", Object.keys(COUNTRY_CODES));
}

// CLI usage
if (require.main === module) {
  demonstrateUsage();
}