#!/bin/bash

echo "============================================"
echo "🔥 Auto Terraform Destroy + Azure Cleanup"
echo "============================================"

FOLDER="terraform-azure"
BACKEND_RG="rg-tfstate"

# Find storage account name from backend.tf
STORAGE_ACCOUNT=$(grep "storage_account_name" $FOLDER/backend.tf | awk -F\" '{print $2}')
CONTAINER_NAME=$(grep "container_name" $FOLDER/backend.tf | awk -F\" '{print $2}')

echo "⏳ Terraform Destroy Starting..."

cd $FOLDER

terraform init >/dev/null

terraform destroy -auto-approve

echo "✔ Terraform resources destroyed"

cd ..

echo "⏳ Cleaning backend resources..."

# Delete container
az storage container delete \
  --account-name $STORAGE_ACCOUNT \
  --name $CONTAINER_NAME \
  --auth-mode login >/dev/null

echo "✔ Container deleted"

# Delete storage account
az storage account delete \
  -n $STORAGE_ACCOUNT \
  -g $BACKEND_RG \
  --yes >/dev/null

echo "✔ Storage account deleted"

# Delete backend Resource Group
az group delete -n $BACKEND_RG --yes --no-wait >/dev/null

echo "✔ Backend Resource Group deletion started"

# Optional: delete local folder
rm -rf terraform-azure

echo "============================================"
echo "🔥 CLEANUP COMPLETE — Everything Destroyed"
echo "🔥 Terraform infra + backend fully removed"
echo "============================================"
