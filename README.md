## Prerequisites

* Set up $150 Azure credit at [https://my.visualstudio.com/](https://my.visualstudio.com/)
* Create personal GitHub Account

### Install Tools
Open Powershell or other tool to run below commands.
* winget install Hashicorp.Terraform
* winget install Git.Git
* winget install GitHub.cli
* winget install --exact --id Microsoft.AzureCLI
* winget install python3
* Install Visual Studio Code [https://code.visualstudio.com/download](https://code.visualstudio.com/download)
  * Install extensions:
    * HashiCorp Terraform

## Login to GitHub
```
gh auth login
```

## Clone Training Repo
Make sure everyone can access [https://github.com/Sapphire-Health/odb-terraform-lab](https://github.com/Sapphire-Health/odb-terraform-lab)
```
mkdir $env:USERPROFILE\source
cd $env:USERPROFILE\source
git clone https://github.com/Sapphire-Health/odb-terraform-lab.git
# delete .git directory to start fresh
cd odb-terraform-lab
Get-Item -Path .git -Force | Remove-Item -Recurse -Force
```

## Login with AZ CLI
```
az login --use-device-code
az account list --output table
az account set --subscription "0000000000000"
```

## Setup Azure Environment
* Enable encryption at host on the subscription
```
az feature register `
  --namespace Microsoft.Compute `
  --name EncryptionAtHost
```
* Create a Unique Name for the Storage Account
```
$storageAccountName = "saterraformlyas" # <-- MUST_BE_UNIQUE
```
* Create a resource group
```
az group create --name RG-Terraform --location westus2
```
* Create a storage account
```
az storage account create --name $storageAccountName --resource-group RG-Terraform --location westus2 --sku Standard_LRS
```
* Create a container
```
az storage container create --name lab-tfstate --account-name $storageAccountName
```
* Create a file share
```
az storage share create --name ansible-persistence --account-name $storageAccountName
```
* Create a user assigned identity
```
$identity = az identity create `
  --name ansible_container `
  --resource-group RG-Terraform `
  --location westus2 `
  --query "{id:id, principalId:principalId}" `
  -o json | ConvertFrom-Json
```
* Give user assigned identity read privileges to subscription
```
$subscriptionId = (az account show --query id -o tsv)
az role assignment create `
  --assignee-object-id $identity.principalId `
  --assignee-principal-type ServicePrincipal `
  --role Reader `
  --scope "/subscriptions/$subscriptionId"
```

## Test Connection to Container
```
az container exec --resource-group prod-hsw-westus2-rg --name prod-ansible-westus2-containergroup --exec-command "/bin/bash"
source ~/venv/azure/bin/activate
ansible -i inventory.azure_rm.yml -m ansible.builtin.ping ODBTST
```
