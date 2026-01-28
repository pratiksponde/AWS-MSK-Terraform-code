output "cluster_arn" {
    value = aws_msk_serverless_cluster.MSK-Cluster.arn
}

output "bootstrap_brokers" {
    value = aws_msk_serverless_cluster.MSK-Cluster.bootstrap_brokers_sasl_iam
}

output "security_group_ids" {
    value = aws_security_group.MSK-Security-Group.id
}