

---

# ✅ **TERRAFORM + AZURE + WINDOWS + VS CODE — COMPLETE GUIDE WITH FOLDER STRUCTURE**

---

# 🟦 **1. Install Required Tools (Windows + Azure)**

## ✔ 1.1 Install Terraform (Windows)

Using Chocolatey (recommended):

```powershell
choco install terraform
terraform -v
```

Manual download (optional):
[https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

---

## ✔ 1.2 Install Azure CLI

```powershell
winget install -e --id Microsoft.AzureCLI
az login
```

---

## ✔ 1.3 Install Git

```powershell
winget install -e --id Git.Git
```

---

## ✔ 1.4 Install VS Code + Required Extensions

Download VS Code:
[https://code.visualstudio.com/download](https://code.visualstudio.com/download)

Inside VS Code, install these extensions:

* HashiCorp Terraform
* Azure CLI Tools
* Azure Account
* Prettier
* GitLens
* YAML

---

# 🟦 **2. REQUIRED FOLDER STRUCTURE (VERY IMPORTANT)**

This is the **official, industry-grade Terraform folder structure** for Azure.

---

# 🟩 **2.1 Basic Folder Structure (Beginners)**

```
terraform-azure/
│── main.tf
│── variables.tf
│── outputs.tf
│── versions.tf
│── backend.tf
```

---

# 🟩 **2.2 Recommended Professional Folder Structure (Multi-Environment)**

```
terraform/
│── global/
│   ├── versions.tf
│   ├── providers.tf
│   └── locals.tf
│
│── modules/
│   ├── resource_group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vnet/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── storage/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
│── envs/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   │
│   ├── test/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   │
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
```



---

# 🟦 **6. Run Terraform from VS Code Terminal**

Open terminal in VS Code:

**Ctrl + `**

---

### ✔ 6.1 Initialize

```powershell
terraform init
```

---

### ✔ 6.2 Validate

```powershell
terraform validate
```

---

### ✔ 6.3 Plan

```powershell
terraform plan
```

---

### ✔ 6.4 Apply

```powershell
terraform apply -auto-approve
```

---

### ✔ 6.5 Verify Resource Group

```powershell
az group list -o table
```

---

### ✔ 6.6 Destroy

```powershell
terraform destroy -auto-approve
```

---

# 🟦 **7. Multi-Environment Workflow (dev/test/prod)**

### Example dev folder:

`envs/dev/terraform.tfvars`

```hcl
location = "eastus"
environment = "dev"
```

### Run from inside the folder:

```powershell
cd terraform/envs/dev
terraform init
terraform apply -var-file="terraform.tfvars"
```

---

# 🟦 **8. How to Use VS Code with Terraform (Important)**

### ✔ Auto-format code

Press: **Shift + Alt + F**

### ✔ Auto-complete

When typing `azurerm_` VS Code suggests all Azure resources.

### ✔ Built-in validation

Terraform extension highlights:

* errors
* unused variables
* incorrect resource names

---

# 🟦 **9. Complete Workflow Summary**

| Step | Task                              |
| ---- | --------------------------------- |
| 1    | Install Terraform, Azure CLI, Git |
| 2    | Login to Azure                    |
| 3    | Open VS Code                      |
| 4    | Create folder structure           |
| 5    | Add `versions.tf`, `main.tf` etc  |
| 6    | (Optional) Setup backend          |
| 7    | Run `terraform init`              |
| 8    | Run `terraform plan`              |
| 9    | Run `terraform apply`             |
| 10   | Verify in Azure                   |
| 11   | Run `terraform destroy`           |

This is your **perfect Terraform + Azure workflow on Windows**.

---

# 🟩 **Do you want the folder structure zipped as a ready-made template?**

I can generate a **downloadable ready-to-use Terraform Azure project** with:

✔ modules
✔ dev/test/prod
✔ backend config
✔ resource group + vnet + storage
✔ READ-ME instructions

Just say **YES, generate template**.
