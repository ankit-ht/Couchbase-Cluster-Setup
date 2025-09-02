output "couchbase_public_ips" {
  value = aws_instance.couchbase_nodes[*].public_ip
}

output "couchbase_private_ips" {
  value = aws_instance.couchbase_nodes[*].private_ip
}
