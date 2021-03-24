resource "aws_security_group" "dc-secgroup" {
  name        = "dc-secgroup"
  description = "Allow HTTP inbound connections"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dc-secgroup"
  }
}

resource "aws_launch_configuration" "dc-conf" {
  name_prefix = "dc-"

  image_id = "ami-0533f2ba8a1995cf9" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  security_groups = [aws_security_group.dc-secgroup.id]
  associate_public_ip_address = true
  user_data = file("hostname.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb_http" {
  name        = "alb_http"
  description = "Allow HTTP traffic to instances through Application Load Balancer"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_http"
  }
}

resource "aws_autoscaling_group" "dc-asg" {
  name = "dc-asg"

  min_size             = 2
  desired_capacity     = 2
  max_size             = 3
  
  health_check_type    = "ELB"
  #load_balancers = [module.alb.this_lb_id]
  target_group_arns = module.alb.target_group_arns
  launch_configuration = aws_launch_configuration.dc-conf.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = module.vpc.public_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
	ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "dc-asg"
    propagate_at_launch = true
  }

}

output "elb_dns_name" {
  value = module.alb.this_lb_dns_name
}
