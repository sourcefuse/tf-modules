variable "InstanceType" {
  default = "t2.large"
  description = "type of ec2 instance"
}

variable "InstanceRootBlockSize" {
  default =  30
}
variable "AttachPublicIp" {
  default = true
}


resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix = "ecs-launch-config"
  image_id = "${var.AmiId}"
  instance_type = "${var.InstanceType}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  key_name = "${var.InstanceKeyPairName}"

  root_block_device = {
      volume_type = "gp2"
      volume_size = "${var.InstanceRootBlockSize}"
      delete_on_termination = true
  }
  associate_public_ip_address = "${var.AttachPublicIp}"

  security_groups = ["${aws_security_group.instance_port.id}"]
  user_data  = <<EOF
                #!/bin/bash
                echo ECS_CLUSTER=${var.ECS_CLUSTER_NAME} >> /etc/ecs/ecs.config
               EOF

  lifecycle = {
    create_before_destroy = true
  }
}
