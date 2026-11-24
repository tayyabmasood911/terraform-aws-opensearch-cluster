variable "aws_region" {
  type        = string
  description = "Target AWS region for OpenSearch deployment"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging)"
  default     = "production"
}

variable "domain_name" {
  type        = string
  description = "Unique name for the OpenSearch domain"
  default     = "prod-search-cluster"
}

variable "engine_version" {
  type        = string
  description = "OpenSearch engine version"
  default     = "OpenSearch_2.11"
}

variable "instance_type" {
  type        = string
  description = "Instance type for data nodes"
  default     = "r6g.large.search"
}

variable "instance_count" {
  type        = number
  description = "Total number of data nodes across AZs"
  default     = 3
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "Enable Multi-AZ zone awareness"
  default     = true
}

variable "availability_zone_count" {
  type        = number
  description = "Number of Availability Zones for zone awareness (2 or 3)"
  default     = 3
}

variable "dedicated_master_enabled" {
  type        = bool
  description = "Whether dedicated master nodes are enabled"
  default     = true
}

variable "dedicated_master_type" {
  type        = string
  description = "Instance type for dedicated master nodes"
  default     = "c6g.large.search"
}

variable "dedicated_master_count" {
  type        = number
  description = "Number of dedicated master nodes (must be 3 or 5)"
  default     = 3
}

variable "warm_enabled" {
  type        = bool
  description = "Enable UltraWarm storage nodes"
  default     = false
}

variable "warm_type" {
  type        = string
  description = "Instance type for UltraWarm storage nodes"
  default     = "ultrawarm1.medium.search"
}

variable "warm_count" {
  type        = number
  description = "Number of UltraWarm storage nodes"
  default     = 2
}

variable "ebs_volume_type" {
  type        = string
  description = "EBS storage volume type (gp3, io1)"
  default     = "gp3"
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS volume size in GiB per node"
  default     = 100
}

variable "ebs_iops" {
  type        = number
  description = "Provisioned IOPS for gp3 storage"
  default     = 3000
}

variable "ebs_throughput" {
  type        = number
  description = "Provisioned throughput in MB/s for gp3 storage"
  default     = 125
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the OpenSearch domain will be placed"
  default     = "vpc-0123456789abcdef0"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC private subnet IDs matching availability zone count"
  default     = ["subnet-0123456789abcdef0", "subnet-0abcdef1234567890", "subnet-0987654321fedcba0"]
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to connect to the cluster over HTTPS"
  default     = ["10.0.0.0/16"]
}

variable "kms_key_arn" {
  type        = string
  description = "Customer Managed KMS Key ARN for encryption at rest (null uses default AWS key)"
  default     = null
}

variable "internal_user_database_enabled" {
  type        = bool
  description = "Enable internal user database for Fine-Grained Access Control"
  default     = true
}

variable "master_user_name" {
  type        = string
  description = "Master administrator username for OpenSearch internal database"
  default     = "admin"
}

variable "master_user_password" {
  type        = string
  description = "Master administrator password for OpenSearch internal database"
  sensitive   = true
  default     = "Str0ngP@ssw0rd!2026"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all OpenSearch resources"
  default     = {}
}
