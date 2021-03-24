module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
 
  name = "dc-vpc"
  cidr = "10.0.0.0/16"
 
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
 
  enable_nat_gateway = true
 
  tags = {
    Terraform = "true"
	Name = "dc-vpc"
  }
}