Sample project
---

This repository contains the infrastructure for sample project.  
Assume that, this server is located in the AWS region `eu-central-1`.  

Allocated CIDR blocks per env.  
Bastion - `172.15.0.0/18` - CIDR block partitioned per AZ as:
```
  172.15.0.0/20,
  172.15.16.0/20,
  172.15.32.0/20,
```
PROD - `172.18.0.0/18` - CIDR block partitioned per AZ as:
```
  172.18.0.0/20,
  172.18.16.0/20,
  172.18.32.0/20
```

NOTE: for future envs, allocate subnets only above this CIDR block
`172.18.0.0/18`.  

##### Windows Server machine spec

|Type    | Environment | Server           | Open ports                      | Zone          |Instance type  | Storage space           | URI FQDN (private/public)                                                  |
|--------|-------------|------------------|---------------------------------|---------------|---------------| ------------------------|--------------------------------------------------------------------------|
|Bastion | Generic     | Windows 2012 R2  | 3386       | eu-central-1  | t2.small      | 2 x 100 GB              | ip-172-15-11-85.eu-central-1.compute.internal/bastion.testapp1.com    |
Server  | Prod        | Windows 2012 R2  | 3386 (via bastion only), 443    | eu-central-1  | m5.xlarge     | 1 x 500 GB 1 x 1500 GB  | ip-172-18-15-132.eu-central-1.compute.internal/service1.testapp1.com     |

##### Terraform

You need to have a `~/.aws/credentials` profile with your access
key and secret key.  

Execution of environments should be done via targeted terraform plan and apply.
e.g.

If you want to modify the VPC in the `prod` env

```
terraform plan -out testrun -var-file=projects.tfvars -target=module.vpc
terraform apply testrun
```
"testrun" is added to .gitignore so don't use a different name and generate a
new binary and then commit it to the repo by mistake.  
