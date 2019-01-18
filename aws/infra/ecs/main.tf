

#Create ECS  Cluster

variable "ECS_CLUSTER_NAME" {
  default = "terraform-ecs-cluster"
}
resource "aws_ecs_cluster" "ecs" {
  name = "${var.ECS_CLUSTER_NAME}"
  tags = "${var.TAGS}"
}


