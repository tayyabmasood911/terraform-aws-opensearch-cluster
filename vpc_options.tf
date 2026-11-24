# -----------------------------------------------------------------------------
# OpenSearch Security Group
# -----------------------------------------------------------------------------
resource "aws_security_group" "opensearch" {
  name        = "${var.domain_name}-sg"
  description = "Security group for OpenSearch cluster VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound HTTPS traffic from authorized VPC CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.domain_name}-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# CloudWatch Log Groups for OpenSearch Slow & Error Logs
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "opensearch_index_slow" {
  name              = "/aws/opensearch/${var.domain_name}/index-slow-logs"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "opensearch_search_slow" {
  name              = "/aws/opensearch/${var.domain_name}/search-slow-logs"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "opensearch_app_logs" {
  name              = "/aws/opensearch/${var.domain_name}/app-logs"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_logs" {
  policy_name = "${var.domain_name}-cw-log-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "es.amazonaws.com"
        }
        Action = [
          "logs:PutLogEvents",
          "logs:PutLogEventsBatch",
          "logs:CreateLogStream"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/opensearch/*:*"
      }
    ]
  })
}
