terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }

  # State remoto compartilhado entre execuções de CI, com locking nativo
  # (use_lockfile) para runs concorrentes. Bucket criado uma única vez via
  # workflow bootstrap-state.yml (workflow_dispatch manual).
  backend "s3" {
    bucket       = "oficina-tfstate-231136242237"
    key          = "infra-k8s/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
