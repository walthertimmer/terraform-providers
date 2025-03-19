# Setting up Terraform Provider Mirror on GitHub

This repository acts as a Terraform provider mirror for airgapped environments. It contains specific versions of the AzureRM and Time providers.

## Repository Structure

The repository follows the [Terraform provider registry protocol](https://www.terraform.io/docs/internals/provider-registry-protocol.html) structure:
```
terraform-providers/
├── terraform-provider-azurerm/
│   ├── index.json
│   ├── 3.0.0/
│   │   ├── download/
│   │   │   ├── linux/
│   │   │   │   └── amd64/
│   │   │   │       ├── terraform-provider-azurerm_3.0.0_linux_amd64.zip
│   │   │   │       └── SHA256SUMS
│   │   │   ├── darwin/
│   │   │   │   └── ...
│   │   │   └── windows/
│   │   │       └── ...
│   │   └── terraform-provider-azurerm_3.0.0.json
│   └── [other versions]
└── terraform-provider-time/
    └── [similar structure]
```
