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
  type = string
  # t3.small: tipo elegível para Free Tier, suficiente para os pods de
  # sistema do EKS (kube-proxy, CNI, CoreDNS) + a carga da aplicação.
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
