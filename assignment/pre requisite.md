 **“Pre-Deployment Checklist”** — everything that needs to be created **before** executing the Terraform.

---

# 🟦 **PRE-DEPLOYMENT CHECKLIST (Must Be Done Before Terraform Apply)**

This section covers **everything you need to set up manually** so Terraform does not fail.

---

# ✅ **1. Install Tools (Mandatory)**

Install:

### ✔ Terraform

```
brew install terraform   # mac
choco install terraform  # windows
```

### ✔ Azure CLI

```
brew install azure-cli
```

### ✔ Ensure Azure CLI is logged in

```
az login
```

### ✔ Set active subscription

```
az account show
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

---

# ✅ **2. Create Terraform Backend (Manually Once)**

Terraform needs a place to store the `tfstate`.

### Step A — Create Resource Group

```
az group create -n rg-demo-tfstate -l eastus
```

### Step B — Create Storage Account

(MUST BE globally unique → change name if needed)

```
az storage account create \
  -n demotfstate12345 \
  -g rg-demo-tfstate \
  -l eastus \
  --sku Standard_LRS
```

### Step C — Create Container

```
az storage container create \
  --name tfstate \
  --account-name demotfstate12345
```

**This backend is used by all environments (dev/test/prod).**

---

# ✅ **3. Generate an SSH Key on Your Machine (Required for VMSS)**

VM Scale Sets require an SSH key to connect.

### Create SSH Key

```
ssh-keygen -t rsa -b 4096
```

### It will create:

* `~/.ssh/id_rsa`
* `~/.ssh/id_rsa.pub`

Terraform uses:

```
file("~/.ssh/id_rsa.pub")
```

### Validate key:

```
ls ~/.ssh
```

You MUST see:

```
id_rsa  id_rsa.pub
```

---

# ✅ **4. Create the Folder Structure Locally**

Run:

```
mkdir terraform-demo-ecommerce
cd terraform-demo-ecommerce
```

Copy-paste all modules and env folders exactly as provided.

This ensures Terraform does not break due to missing files.

---

# ✅ **5. Update Backend Storage Name (Important)**

In:

```
global/backend.tf
```

ensure:

```
storage_account_name = "demotfstate12345"
```

If the name changes → update here also.

---

# ✅ **6. Log in with the user who has Required Roles**

The account running terraform needs:

### **Minimum Access Required:**

| Resource        | Required Role |
| --------------- | ------------- |
| Resource Groups | Contributor   |
| Network         | Contributor   |
| VMSS            | Contributor   |
| PostgreSQL      | Contributor   |
| Redis           | Contributor   |
| Storage         | Contributor   |
| Key Vault       | Contributor   |
| Private DNS     | Contributor   |

Best role to use:

```
Owner (for your subscription)
```

---

# ✅ **7. Make Sure You Have Sufficient Quota**

VM Size used: **Standard_B2s**

Check quota:

```
az vm list-usage -l eastus -o table
```

Look for:

```
Standard_B Family vCPUs
```

You need min 4 vCPUs for VMSS.

---

# ✅ **8. Make Sure 22 Port is Allowed from Your IP (Optional)**

If you want SSH access to VMSS nodes:

Add to NSG:

```
22 → Your IP Only
```

(Terraform script currently does not add public SSH — you can add later.)

---

# 🟦 **AFTER ALL ABOVE → YOU ARE READY TO RUN TERRAFORM**

## Step 1 — Go to dev:

```
cd envs/dev
terraform init
terraform plan
terraform apply -auto-approve
```

## Step 2 — For test:

```
cd ../test
terraform init
terraform apply
```

## Step 3 — For prod:

```
cd ../prod
terraform init
terraform apply
```

---

# 🟩 **OPTIONAL — Recommended Before Running Prod**

✔ Validate dev environment
✔ Ensure NSG, VNET, VMSS behavior
✔ Ensure PostgreSQL/Redis reachable
✔ Ensure KeyVault secrets populated
✔ Review costs in Azure Calculator

---

