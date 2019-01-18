data "aws_iam_policy_document" "ecs-instance-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

variable "AttachExtraPolicies" {
  type = "list"
  default = []
}


resource "aws_iam_role" "ecs-instance-role" {
    name_prefix                = "ecs-instance-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}


resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
    role       = "${aws_iam_role.ecs-instance-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_ssm_role" {
    count = "${length(var.AttachExtraPolicies)}"
    role = "${aws_iam_role.ecs-instance-role.name}"
    policy_arn = "${element(var.AttachExtraPolicies, count.index)}"
}


resource "aws_iam_instance_profile" "ecs-instance-profile" {
    name = "ecs-instance-profile"
    path = "/"
    role = "${aws_iam_role.ecs-instance-role.id}"
    provisioner "local-exec" {
      command = "sleep 10"
    }
}