output "ECS_CLUSTER_ID" {
  value = "${aws_ecs_cluster.ecs.id}"
}

output "ECS_SERVICE_ROLE" {
  value = "${aws_iam_role_policy_attachment.ecs-service-role-attachment.id}"
}

output "ELB_ENDPOINT" {
  value = "${aws_elb.elb_http.dns_name}"
}

output "ELB_NAME" {
  value = "${aws_elb.elb_http.name}"
}

