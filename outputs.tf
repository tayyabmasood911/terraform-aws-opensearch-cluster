output "domain_id" {
  description = "Unique identifier of the OpenSearch domain"
  value       = aws_opensearch_domain.cluster.domain_id
}

output "domain_arn" {
  description = "Amazon Resource Name (ARN) of the OpenSearch domain"
  value       = aws_opensearch_domain.cluster.arn
}

output "domain_endpoint" {
  description = "Domain-specific endpoint used to submit index and search requests"
  value       = aws_opensearch_domain.cluster.endpoint
}

output "dashboard_endpoint" {
  description = "Domain-specific endpoint for OpenSearch Dashboards (Kibana)"
  value       = aws_opensearch_domain.cluster.dashboard_endpoint
}

output "security_group_id" {
  description = "ID of the security group attached to the OpenSearch cluster"
  value       = aws_security_group.opensearch.id
}
