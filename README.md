Terraform Module to provision 2 AWS EC2 instances with the latest ubuntu 20.04 ami and installed and configureted k3s cluster with 1 master 1 worker node. 

Not intended for production use. It is an example module.

```hcl

provider "aws" {
  region = "us-east-1"
}

module "k3s-instances" {
    source = "halildikilitas01/k3s-instances/aws"
    key_name = "halil" # your key-name here
}
```
