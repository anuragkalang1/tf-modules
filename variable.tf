variable "aws_region" {
  default = "us-west-2"
}

variable "ami" {
  description = "Amazon Machine Image (AMI) provides the information required to launch an instance "
  default = "" #set a defualt ami id
}

variable "instance_type" {
  default = "t2.micro"
}

#mnetion the subnet ids
variable "subnet_id_a" {
  default = ""
}

variable "subnet_id_b" {
  default = ""
}

variable "vpc_sg_ids" {
  type    = "list"
  default = [ "" , "" ] #mention the security group ids
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = "80"
}

variable "del_on_term" {
  default = "true"
}


variable "remote_state_region" {
  default = "us-west-2"
}
