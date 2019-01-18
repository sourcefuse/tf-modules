variable "InstancePort" {
    description = "Open the port on ECS Instances"
  default = "80"
}

variable "InstanceProtocol" {
  description = "Protocol to use with Instance"
  default = "tcp"
}

variable "LbProtocol" {
  default = "tcp"
}

variable "InstanceSshPort" {
  default = 22
}



resource "aws_security_group" "elb_port_80" {
    name_prefix = "ELB_SG"
    description = "Allow Port 80 Traffic"
    vpc_id = "${var.VPC_ID}"

    ingress = {
        from_port = 80
        to_port = 80
        protocol = "${var.LbProtocol}"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress = {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    
    }
    
    tags = "${var.TAGS}"
}

resource "aws_security_group" "instance_port" {
  name_prefix = "Instacne_SG"
  description = "Allow traffic on specified port"
  vpc_id = "${var.VPC_ID}"

  ingress = {
        from_port = "${var.InstancePort}"
        to_port = "${var.InstancePort}"
        protocol = "${var.InstanceProtocol}"
        security_groups = ["${aws_security_group.elb_port_80.id}"]
  }

  egress = {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    
  }
}
