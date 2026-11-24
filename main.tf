terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# AWS OpenSearch Multi-AZ Domain
# -----------------------------------------------------------------------------
resource "aws_opensearch_domain" "cluster" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }

    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_type
    dedicated_master_count   = var.dedicated_master_count

    warm_enabled = var.warm_enabled
    warm_type    = var.warm_enabled ? var.warm_type : null
    warm_count   = var.warm_enabled ? var.warm_count : null
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    iops        = var.ebs_volume_type == "gp3" ? var.ebs_iops : null
    throughput  = var.ebs_volume_type == "gp3" ? var.ebs_throughput : null
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kms_key_arn
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.opensearch.id]
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_index_slow.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_search_slow.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_app_logs.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  tags = merge(
    var.tags,
    {
      Domain      = var.domain_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )

  depends_on = [aws_cloudwatch_log_resource_policy.opensearch_logs]
}

# -----------------------------------------------------------------------------
# OpenSearch Access Policy (Allow VPC access)
# -----------------------------------------------------------------------------
resource "aws_opensearch_domain_policy" "access_policy" {
  domain_name = aws_opensearch_domain.cluster.domain_name

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "es:*"
        Resource = "${aws_opensearch_domain.cluster.arn}/*"
      }
    ]
  })
}
