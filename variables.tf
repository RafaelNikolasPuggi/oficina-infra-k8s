variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "oficina-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "cluster_name" {
  type    = string
  default = "oficina-eks"
}


variable "node_instance_type" {
  type    = string
  # t3.medium não é aceito nesta conta (restrição de Free Tier em contas
  # novas — InvalidParameterCombination: "not eligible for Free Tier").
  # t3.small está na lista de tipos free-tier-eligible confirmada via
  # `aws ec2 describe-instance-types --filters Name=free-tier-eligible,Values=true`.
  default = "t3.small"
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}
