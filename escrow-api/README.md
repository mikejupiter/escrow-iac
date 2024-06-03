# Escrow API backend


## Run

```shell
terraform init
terraform plan -var-file="../env/dev.tfvars"
terraform apply -var-file="../env/dev.tfvars"
```

## todo

Consider to create the special execution role and other than standard set of permissions add the log:CreateLogGroup 