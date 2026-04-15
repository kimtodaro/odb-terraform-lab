# define env vars
```
export TF_VAR_default_password="Loc@lPassw0rd"
```

# init
```
terraform -chdir=src init -backend-config=storage_account_name=saterraformkim -backend-config=container_name=lab-tfstate -backend-config=key=lab -backend-config=resource_group_name=RG-Terraform -backend-config=subscription_id=2a01f1d8-526d-49c3-8ea4-512bb8e0a586 -backend-config=tenant_id=ad46683f-d0ff-42c7-a2d0-1fdcba869d0a
```

# plan
```
terraform -chdir=src plan -var-file="../environments/lab/terraform.tfvars"
```

# apply
```
terraform -chdir=src apply -var-file="../environments/lab/terraform.tfvars"
```

# destroy
```
terraform -chdir=src destroy -var-file="../environments/lab/terraform.tfvars"
```