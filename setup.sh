#!/bin/bash

echo "============================================"
echo "🔥 Auto Terraform + Azure Backend Setup"
echo "============================================"

# ---------------------------
# Fetch Azure Values
# ---------------------------
echo "⏳ Fetching Subscription & Tenant details..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)
LOCATION="eastus"

if [[ -z "$SUBSCRIPTION_ID" ]]; then
  echo "❌ ERROR: Azure subscription not found. Run: az login"
  exit 1
fi

echo "✔ Subscription: $SUBSCRIPTION_ID"
echo "✔ Tenant: $TENANT_ID"

# ---------------------------
# Create backend resources
# ---------------------------
RG="rg-tfstate"
STORAGE="tfstate$RANDOM"
CONTAINER="tfstate"

echo "⏳ Creating Resource Group..."
az group create -n $RG -l $LOCATION >/dev/null

echo "⏳ Creating Storage Account: $STORAGE..."
az storage account create \
  -n $STORAGE \
  -g $RG \
  -l $LOCATION \
  --sku Standard_LRS >/dev/null

echo "⏳ Creating Storage Container..."
az storage container create \
  --account-name $STORAGE \
  --name $CONTAINER \
  --auth-mode login >/dev/null

echo "✔ Backend Storage Ready"

# ---------------------------
# Create Terraform Folder
# ---------------------------
FOLDER="terraform-azure"
mkdir -p $FOLDER
cd $FOLDER

echo "⏳ Creating Terraform files..."

# ---------------------------
# backend.tf
# ---------------------------
cat <<EOF > backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG"
    storage_account_name = "$STORAGE"
    container_name       = "$CONTAINER"
    key                  = "terraform.tfstate"
  }
}
EOF

# ---------------------------
# versions.tf
# ---------------------------
cat <<EOF > versions.tf
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
EOF

# ---------------------------
# variables.tf
# ---------------------------
cat <<EOF > variables.tf
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
EOF

# ---------------------------
# main.tf
# ---------------------------
cat <<EOF > main.tf
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
  address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 🔥 UPDATED PUBLIC IP BLOCK — STATIC + STANDARD SKU
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
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
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
EOF

# ---------------------------
# outputs.tf
# ---------------------------
cat <<EOF > outputs.tf
output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
EOF

echo "============================================"
echo "🎉 All Terraform files generated automatically!"
echo "🎉 Backend configured!"
echo "🎉 Ready to run:"
echo "    terraform init"
echo "    terraform plan"
echo "    terraform apply -auto-approve"
echo "============================================"
