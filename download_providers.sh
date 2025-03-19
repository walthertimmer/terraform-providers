#!/bin/bash

# Script to download Terraform providers and organize them for a GitHub-based mirror

# Configuration
AZURERM_VERSION="4.26.0"  # Update to desired version
TIME_VERSION="10.0.0"      # Update to desired version
PLATFORMS=("linux_amd64")
BASE_DIR="$(pwd)"

# Create directory structure for AzureRM provider
setup_provider() {
    local provider_name=$1
    local provider_version=$2
    
    for platform in "${PLATFORMS[@]}"; do
        os=$(echo $platform | cut -d'_' -f1)
        arch=$(echo $platform | cut -d'_' -f2)
        
        mkdir -p "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch"
        
        # Download URL for official Terraform providers
        DOWNLOAD_URL="https://releases.hashicorp.com/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}_${platform}.zip"
        
        echo "Downloading $provider_name provider $provider_version for $platform..."
        curl -L "$DOWNLOAD_URL" -o "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch/terraform-provider-${provider_name}_${provider_version}_${platform}.zip"
        
        # Download SHA256SUMS
        SUMS_URL="https://releases.hashicorp.com/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}_SHA256SUMS"
        curl -L "$SUMS_URL" -o "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch/SHA256SUMS"
    done
    
    # Create provider version JSON file
    cat > "$BASE_DIR/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}.json" << EOF
{
  "version": "$provider_version",
  "protocols": ["5.0"],
  "platforms": [
    {"os": "linux", "arch": "amd64"}
  ]
}
EOF

    # Create provider index.json
    cat > "$BASE_DIR/terraform-provider-$provider_name/index.json" << EOF
{
  "versions": ["$provider_version"]
}
EOF
}

echo "Setting up AzureRM provider..."
setup_provider "azurerm" "$AZURERM_VERSION"

echo "Setting up Time provider..."
setup_provider "time" "$TIME_VERSION"

echo "Done! Provider files are ready for commit to your GitHub repository."
