# Plan for Escrow IaC


## Research

### Questions

- Can we have single point of entry like WAF (kind of Imperva) so we can reserve
only one public IP address and rest of routing do onto internal IPs?

### General Terraform and Ansible research
+ +Get AWS creds to run terraform against the our account
+ +Create and run simple script to create/destroy bucket
- Create a VM with reserved IP
- Organize the file structure to run scripts
- provision the Escrow service as Fargate/ECS
  - find out what do we need? Fargate task, ALB, ECS, VPC etc
- prepare local WLS(Linux) env to run Ansible
- add Ansible scripts to install software on the VM
- Create the jumpbox VM


### Jenkins efforts

- create simple Job to print Hello World
- Find the way to run this Job on the Fargate task container spawn before to run jub
- build escrow-api on container
- find out what could a best way to store our artifacts
   -- archiva (filesystem vs bucket)
   -- bucket
- generate the Dockerfile and find out where it would be the best to store it
- deploy the service to ECS/Fargate 


### DB

- Find out would it be better to switch from Pg to Aurora