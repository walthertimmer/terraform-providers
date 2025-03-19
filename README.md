# Terraform Provider Mirror on GitHub

This repository serves as a Terraform provider mirror for airgapped environments. It contains the AzureRM and Time providers that can be used in environments without direct access to the official Terraform Registry.

## Usage

To use these providers in your airgapped environment, add the following to your Terraform configuration:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "github.com/YOUR_USERNAME/terraform-providers/azurerm"
      version = "3.75.0" # Or whichever version you've mirrored
    }
    time = {
      source  = "github.com/YOUR_USERNAME/terraform-providers/time"
      version = "0.9.1" # Or whichever version you've mirrored
    }
  }
}
```

Then update your Terraform CLI configuration file (`~/.terraformrc` or `%APPDATA%\terraform.rc`) to include:

```hcl
provider_installation {
  network_mirror {
    url = "https://github.com/YOUR_USERNAME/terraform-providers/raw/main/"
  }
  direct {
    exclude = ["github.com/YOUR_USERNAME/terraform-providers/*"]
  }
}
```

## Available Providers

- AzureRM: v3.75.0 (update this to the actual version you've published)
- Time: v0.9.1 (update this to the actual version you've published)

## Adding New Providers or Versions

Run the `download_providers.sh` script to download and organize new providers or versions. Edit the script to update versions as needed.

```bash
chmod +x download_providers.sh
./download_providers.sh
```

After running the script, commit and push the changes to GitHub.
