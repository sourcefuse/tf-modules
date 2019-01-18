data "aws_iam_policy_document" "ecs-service-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}


#IAM Roles


#ECS Service Role
resource "aws_iam_role" "ecs-service-role" {
  name_prefix = "ecs_service_role"
  path = "/"
  assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}


resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = "${aws_iam_role.ecs-service-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}



