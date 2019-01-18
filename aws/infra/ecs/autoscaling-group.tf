variable "AsgMax" {
  default = 1
}
variable "AsgMin" {
  default = 1
}

variable "AsgDesired" {
  default = 1
}
variable "AsgHealthCheckType" {
  default = "ELB"
}


resource "aws_autoscaling_group" "ecs_autoscaling_group_name" {
  name_prefix = "ecs-autoscaling-group"
  max_size = "${var.AsgMax}"
  min_size = "${var.AsgMax}"
  desired_capacity = "${var.AsgMin}"
  vpc_zone_identifier = ["${var.SUBNET_LIST}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_config.name}"
  health_check_type = "${var.AsgHealthCheckType}"
  load_balancers = ["${aws_elb.elb_http.name}"]

  lifecycle = {
    create_before_destroy = true
  }
  #suspended_processes = ["Terminate"]
}
