#!/bin/bash

# Script to download Terraform providers and organize them for a GitHub-based mirror

# Configuration
AZURERM_VERSION="4.26.0"  # Update to desired version
TIME_VERSION="10.0.0"      # Update to desired version
DATABRICKS_VERSION="1.68.0"  # Update to desired version
PLATFORMS=("linux_amd64" "windows_amd64" "darwin_amd64")
BASE_DIR="$(pwd)"

# Create directory structure for AzureRM provider
setup_provider() {
    local provider_name=$1
    local provider_version=$2
    local provider_namespace=$3  # Optional namespace parameter, defaults to hashicorp

    if [ -z "$provider_namespace" ]; then
        provider_namespace="hashicorp"
        download_url_base="https://releases.hashicorp.com"
    else
        # For non-HashiCorp providers, use the Terraform Registry API
        download_url_base="https://releases.hashicorp.com"
        if [ "$provider_namespace" != "hashicorp" ]; then
            echo "Using Terraform Registry API for $provider_namespace/$provider_name"
            download_url_base="https://releases.hashicorp.com"
        fi
    fi
    
    for platform in "${PLATFORMS[@]}"; do
        os=$(echo $platform | cut -d'_' -f1)
        arch=$(echo $platform | cut -d'_' -f2)

        # Add platform to JSON
        if [ "$os" == "linux" ] && [ "$arch" == "amd64" ]; then
            platforms_json+=$'\n    {"os": "linux", "arch": "amd64"},'
        elif [ "$os" == "windows" ] && [ "$arch" == "amd64" ]; then
            platforms_json+=$'\n    {"os": "windows", "arch": "amd64"},'
        elif [ "$os" == "darwin" ] && [ "$arch" == "amd64" ]; then
            platforms_json+=$'\n    {"os": "darwin", "arch": "amd64"},'
        fi
        
        mkdir -p "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch"
        
        # Download URL for official Terraform providers
        DOWNLOAD_URL="https://releases.hashicorp.com/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}_${platform}.zip"

        ZIP_PATH="$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch/terraform-provider-${provider_name}_${provider_version}_${os}_${arch}.zip"
        EXTRACT_DIR="$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch"
        
        echo "Downloading $provider_name provider $provider_version for $platform..."
        curl -L "$DOWNLOAD_URL" -o "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch/terraform-provider-${provider_name}_${provider_version}_${platform}.zip"
        
            # Extract the zip file
        unzip -o "$ZIP_PATH" -d "$EXTRACT_DIR"

        # Make the binary executable
        chmod +x "$EXTRACT_DIR/terraform-provider-${provider_name}_v${provider_version}"

        # Download SHA256SUMS
        SUMS_URL="https://releases.hashicorp.com/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}_SHA256SUMS"
        curl -L "$SUMS_URL" -o "$BASE_DIR/terraform-provider-$provider_name/$provider_version/download/$os/$arch/SHA256SUMS"

    done
    
    # Create provider version JSON file
    cat > "$BASE_DIR/terraform-provider-$provider_name/$provider_version/terraform-provider-${provider_name}_${provider_version}.json" << EOF
{
  "version": "$provider_version",
  "protocols": ["5.0"],
  "platforms": $platforms_json
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

echo "Setting up Databricks provider..."
setup_provider "databricks" "$DATABRICKS_VERSION" "databricks"

echo "Done! Provider files are ready for commit to your GitHub repository."
