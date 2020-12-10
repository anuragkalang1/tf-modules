provider "aws" {
   region = "${var.aws_region}"
   version = "<= 2.8.0"
 }

terraform {
  required_version = "= 0.13"
  backend "s3" {}
}

data "aws_security_group" "ports" {
   name = "test"
   vpc_id = "${local.vpc_id}"
}

resource "aws_security_group" "test1" {
   vpc_id = "${local.vpc_id}"
   count = "${var.namespace_enabled}"
   
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    security_groups = ["${data.aws_security_group.ports.id}"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "test" {
  name               = "helloworld-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [test1.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true

  access_logs {
    bucket  = helloworld.lb_logs.bucket
    prefix  = "helloworld-lb"
    enabled = true
  }
}

resource "aws_launch_configuration" "hello_world_deploy" {
  name_prefix                   = "Helloworld-"
  image_id                      = "${var.ami}"
  key_name                      = "${var.keypair}"
  associate_public_ip_address   = false    
  instance_type                 = "${var.instance_type}"  
  security_groups 			        = ["${aws_security_group.test1.id}"] 
  root_block_device {        
    volume_type 				        = "${var.volume_type}"
    volume_size 				        = "${var.volume_size}"
    delete_on_termination 			= "${var.del_on_term}"
  }
  lifecycle {
    create_before_destroy = true
  }
  user_data = "${base64encode(data.template_file.helloworld_data)}"
}

resource "aws_autoscaling_group" "hello_world_asg" {
  name                 = "helloworld-asg"
  launch_configuration = "aws_launch_configuration.hello_world_deploy"
  health_check_type    = "EC2"
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1 
  
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "helloworld_data" {
  template = <<EOF
                              
    <shell>
    # Add the code to be deployed, I am deploying using ansible
    #Note: This infrastructure should be created before we run the ansible playbook
    <shell>
    <persist>true</persist>
EOF
}
