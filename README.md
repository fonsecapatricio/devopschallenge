# devopschallenge

DevOps Challenge (dc)

## Description

Using Terraform:

* Create a VPC with 2 public subnets in two different availability zones, an application load balancer with an autoscaling group with desired
capacity = 2 EC2 instances.

With ansible:

* Deploy a Node.js chat application to EC2 previously created instances. 

## Getting Started

### Dependencies

* Terraform installed an configured to use with AWS provider.
* Ansible installed and configured to use with AWS provider.

### Installing

* Clone the repo

* For terraform you have to edit /devopschallenge/provider.tf and provide your Access key ID, Secret Access Key and AWS region

* For Ansible i used amazon.aws.aws_ec2 plugin for hosts dynamic inventory, you have to enable it in your ansible.cfg file at inventory section

```
enable_plugins = aws_ec2
``` 

* Add the new Ansible's inventory path at default section

```
inventory = ~/devopschallenge/ansible/inventory/aws_ec2.yaml
```

* Provide your Access key ID, Secret Access Key, and AWS region in aws_ec2.yaml file

* Edit file devopschallenge/ansible/deploy_app.yaml and provide the path to your .pem file to SSH EC2 Instances.
### Executing program

* To generate infrastructure with terraform, run the following commands in your working directory

```
terraform init
```
```
terraform plan
```
```
terraform apply          
```

* To deploy the application on EC2 instances execute deploy_app.yaml playbook.

```
ansible-playbook deploy_app.yaml
```
