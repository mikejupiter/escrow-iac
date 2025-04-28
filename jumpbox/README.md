# Jumpbox VM


## Prepare

### Access via CLI

You'll need IAM user to access the VM using Terraform.
1) Got to AWS Console and search for IAM
2) Create a new IAM with `AdministratorAccess` policy. You can create the new `Role` with this policy or attach it directly to the new IAM
3) Create the `Acccess Key`
4) On the host where you'll run the `terraform` you need to set 2 environment variables:
```
 export AWS_ACCESS_KEY_ID=
 export AWS_SECRET_ACCESS_KEY=
```
5) Synchronize the time on the host:
```
ntpdate -u pool.ntp.org
```


### SSH Key to access VM
Create the host ssh key to be able to get the password
```bash
ssh-keygen -t rsa -b 2048 -C "myname@myhosst.io"

ssh-keygen -p -m PEM -f jumpbox_id_rsa
```

The second command is needed to generate the file for using it with AWS which does not understand OpenSSH format and want RSA format

## Create the env files for terraform:

`terraform/env/dev.tfvars`:
```
aws_region = "us-east-1"
eip = "eipalloc-12345677" 
```

You need to get the ARN for Elastic IP from the output of `eip` module and make sure that EIP has been provisioned

## Running Terraform

First off you need to init the Terraform:

```
terraform init -backend-config="key=jumpbox/terraform.tfstate" -backend-config="bucket=g2sentry-terraform-state-bucket"
```

and now you can `apply`:

```
terraform apply -var-file="./env/dev.tfvars"
```

## Create config env files for Ansible

### Ansible installation

Install ansible.

Install modules:
```
pip install pywinrm
pip install "ansible[windows]"

```

### prepare config

`ansible/env/dev/hosts`:

```
[jumpbox]
jumpbox1 ansible_host=jumpbox.kaboi.com

[jumpbox:vars]
ansible_user=Administrator
ansible_password=OurPassword
ansible_winrm_port=5986
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_winrm_scheme=https
ansible_winrm_server_cert_validation=ignore
ansible_python_interpreter=/usr/bin/python3

```

## Running Ansible

```
ansible-playbook -i env/dev/hosts playbook.yaml
```

# Troubleshooting

### check `WinRm`

On VM:
Checking the listeners
```
winrm enumerate winrm/config/listener
```

Checking the config
```
Winrm get http://schemas.microsoft.com/wbem/wsman/1/config
winrm get winrm/config
```

### time unsync
In case you get some expiration issue like that:
```
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Retrieving AWS account details: validating provider credentials: retrieving caller identity from STS: operation error STS: GetCallerIdentity, https response error StatusCode: 403, RequestID: 8XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX, api error SignatureDoesNotMatch: Signature expired: 20240704T215913Z is now earlier than 20240704T221303Z (20240704T222803Z - 15 min.)
```

Try to sync the time:
```
sudo ntpdate -u pool.ntp.org
```