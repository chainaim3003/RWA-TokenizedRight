import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

/**
 * Replace placeholders in policy JSON with actual deployed addresses
 */
function updatePolicyAddresses(policyFilePath: string, outputPath?: string): string {
  console.log("🔄 Updating policy addresses...");
  
  // Read the policy file
  const policyContent = fs.readFileSync(policyFilePath, 'utf8');
  
  // Read deployment addresses
  let modifiedPretAddress = process.env.MODIFIED_PRET_ADDRESS;
  
  // Try to read from deployment file if not in env
  if (!modifiedPretAddress) {
    try {
      const deploymentContent = fs.readFileSync('deployment-modified.env', 'utf8');
      const match = deploymentContent.match(/MODIFIED_PRET_ADDRESS=(.+)/);
      if (match) {
        modifiedPretAddress = match[1].trim();
      }
    } catch (error) {
      console.warn("⚠️ No deployment file found, using placeholder addresses");
    }
  }
  
  if (!modifiedPretAddress) {
    throw new Error("❌ MODIFIED_PRET_ADDRESS not found. Please deploy the contract first or set environment variable.");
  }
  
  console.log("📍 Using Modified PRET address:", modifiedPretAddress);
  
  // Replace placeholder with actual address
  const updatedContent = policyContent.replace(
    /\{\{MODIFIED_PRET_ADDRESS\}\}/g, 
    modifiedPretAddress
  );
  
  // Write to output file
  const finalOutputPath = outputPath || policyFilePath.replace('.json', '-deployed.json');
  fs.writeFileSync(finalOutputPath, updatedContent, 'utf8');
  
  console.log("✅ Policy addresses updated:", finalOutputPath);
  return finalOutputPath;
}

/**
 * Convert parameters for contract calls using the conversion utilities
 */
async function convertParametersForDemo(): Promise<void> {
  console.log("🔄 Converting parameters for demo...");
  
  const { 
    convertGLEIFParams,
    convertCrossBorderPYUSDParams,
    convertFractionThresholdParams,
    ASSET_TYPES,
    COUNTRY_CODES
  } = await import('./conversion-utilities');
  
  // Example conversions for demo
  console.log("📊 Parameter Conversion Examples:");
  
  // GLEIF conversion
  const gleifParams = convertGLEIFParams("HWUPKR0MPOU8FGXBT394", "APPLE INC");
  console.log("GLEIF:", gleifParams);
  
  // Cross-border conversion  
  const crossBorderParams = convertCrossBorderPYUSDParams("US", "GB", "1000000");
  console.log("Cross-border:", crossBorderParams);
  
  // Asset type conversion
  const fractionParams = convertFractionThresholdParams("TREASURY");
  console.log("Asset type:", fractionParams);
  
  console.log("Available constants:");
  console.log("- Asset Types:", ASSET_TYPES);
  console.log("- Country Codes:", COUNTRY_CODES);
}

// Export functions for use in other scripts
export { updatePolicyAddresses, convertParametersForDemo };

// CLI usage
if (require.main === module) {
  const command = process.argv[2];
  
  if (command === 'updateAddresses') {
    const policyFile = process.argv[3] || 'policies/institutional-complete-14-rules.json';
    const outputFile = process.argv[4];
    updatePolicyAddresses(policyFile, outputFile);
  } else if (command === 'convertParams') {
    convertParametersForDemo();
  } else {
    console.log("📖 Available commands:");
    console.log("  updateAddresses <policyFile> [outputFile] - Replace placeholder addresses");
    console.log("  convertParams - Show parameter conversion examples");
  }
}