# ============================================
# Auto Terraform + Azure Backend Setup (Windows PowerShell)
# ============================================

Write-Host "============================================"
Write-Host "Auto Terraform + Azure Backend Setup"
Write-Host "============================================"

# ---------------------------
# Fetch Azure Values
# ---------------------------
Write-Host "Fetching Subscription & Tenant details..."

$SUBSCRIPTION_ID = az account show --query id -o tsv
$TENANT_ID       = az account show --query tenantId -o tsv
$LOCATION        = "eastus"

if ([string]::IsNullOrWhiteSpace($SUBSCRIPTION_ID)) {
    Write-Host "ERROR: Azure subscription not found. Run: az login"
    exit
}

Write-Host "Subscription: $SUBSCRIPTION_ID"
Write-Host "Tenant: $TENANT_ID"

# ---------------------------
# Create backend resources
# ---------------------------
$RG = "rg-tfstate"
$RANDOM_NUM = Get-Random -Minimum 10000 -Maximum 99999
$STORAGE = "tfstate$RANDOM_NUM"
$CONTAINER = "tfstate"

Write-Host "Creating Resource Group..."
az group create -n $RG -l $LOCATION | Out-Null

Write-Host "Creating Storage Account: $STORAGE..."
az storage account create `
  -n $STORAGE `
  -g $RG `
  -l $LOCATION `
  --sku Standard_LRS | Out-Null

Write-Host "Creating Storage Container..."
az storage container create `
  --account-name $STORAGE `
  --name $CONTAINER `
  --auth-mode login | Out-Null

Write-Host "Backend Storage Ready"

# ---------------------------
# Create Terraform Folder
# ---------------------------
$FOLDER = "terraform-azure"

if (!(Test-Path $FOLDER)) {
    New-Item -ItemType Directory -Path $FOLDER | Out-Null
}

Set-Location $FOLDER

Write-Host "Creating Terraform files..."

# ---------------------------
# backend.tf
# ---------------------------
@"
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG"
    storage_account_name = "$STORAGE"
    container_name       = "$CONTAINER"
    key                  = "terraform.tfstate"
  }
}
"@ | Set-Content -Path backend.tf

# ---------------------------
# versions.tf
# ---------------------------
@"
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "$SUBSCRIPTION_ID"
  tenant_id       = "$TENANT_ID"
}
"@ | Set-Content -Path versions.tf

# ---------------------------
# variables.tf
# ---------------------------
@"
variable "location" {
  default = "eastus"
}

variable "rg_name" {
  default = "rg-demo"
}

variable "vnet_name" {
  default = "vnet-demo"
}

variable "subnet_name" {
  default = "subnet-demo"
}

variable "nsg_name" {
  default = "nsg-demo"
}

variable "pip_name" {
  default = "pip-demo"
}

variable "nic_name" {
  default = "nic-demo"
}

variable "vm_name" {
  default = "vm-demo"
}
"@ | Set-Content -Path variables.tf

# ---------------------------
# main.tf
# ---------------------------
@"
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
"@ | Set-Content -Path main.tf

# ---------------------------
# outputs.tf
# ---------------------------
@"
output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
"@ | Set-Content -Path outputs.tf

Write-Host "============================================"
Write-Host "Terraform files created successfully."
Write-Host ""
Write-Host "Run the following commands:"
Write-Host "terraform init"
Write-Host "terraform plan"
Write-Host "terraform validate"
Write-Host "terraform apply -auto-approve"
Write-Host "============================================"

