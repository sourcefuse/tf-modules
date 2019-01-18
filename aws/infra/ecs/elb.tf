variable "ElbAccesslogBucket" {
  default = ""
}

variable "ElbInterval" {
  default = 60
}

variable "ElbCrossLoadBalancing" {
  default = true
}
variable "ElbConnectionDraining" {
  default = true
}
variable "ElbConnectionDrainingTimeout" {
  default = 400
}

variable "ElbSslArn" {
  default = ""
}



resource "aws_elb" "elb_http" {
  name_prefix = "tf"
  subnets = "${var.SUBNET_LIST}"
  count = "${var.ElbSslArn == ""? 1 : 0}"
  security_groups = ["${aws_security_group.elb_port_80.id}"]
#   access_logs = {
#         bucket_prefix = "tf-elb-log"
#         interval = "${var.ElbInterval}"
#         enabled = true      
#   }


  listener = {
      instance_port = "${var.InstancePort}"
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    health_check = {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "TCP:80"
        interval            = 10
    }
   cross_zone_load_balancing =  "${var.ElbCrossLoadBalancing}"

  tags = "${var.TAGS}"
}

#No count is availabe for sub blocks like listeners, so duplicate resources are required
#TODO: Port to Terraform 0.12 None type once it's avaialbe

resource "aws_elb" "elb_https" {
  name_prefix = "tf"
  subnets = "${var.SUBNET_LIST}"
  count = "${var.ElbSslArn == ""? 0 : 1}"
#   access_logs = {
#       bucket_prefix = "tf-elb-log"
#       interval = "${var.ElbInterval}"
#       enabled = true
#   }


    listener = {
      instance_port = "${var.InstancePort}"
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    listener = {
      instance_port = "${var.InstancePort}"
      instance_protocol = "${var.InstanceProtocol}"
      lb_port = 443
      lb_protocol = "https"
      ssl_certificate_id  = "${var.ElbSslArn}"
    }

    health_check = {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80"
        interval            = 30
    }
  cross_zone_load_balancing =  "${var.ElbCrossLoadBalancing}"
  tags = "${var.TAGS}"

}