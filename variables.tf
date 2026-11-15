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

# --- Orçamento mensal (ver aws_budgets_budget.monthly_cost_guard no main.tf) ---

variable "budget_limit_usd" {
  type    = number
  default = 20
}

variable "budget_alert_email" {
  description = "E-mail que recebe os alertas de orçamento. Vem de um GitHub Secret (TF_VAR_budget_alert_email) — nunca comitado, repositório é público."
  type        = string
  sensitive   = true
}
