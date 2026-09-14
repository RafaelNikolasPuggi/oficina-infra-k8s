# ATENÇÃO — CUSTO REAL: este arquivo provisiona um control plane EKS
# (~US$ 0,10/h), um NAT Gateway (~US$ 0,045/h + tráfego) e 2 instâncias
# t3.medium (~US$ 0,0416/h cada). Rode `terraform destroy` assim que terminar
# de gravar a demonstração — ver README.md.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [cidrsubnet(var.vpc_cidr, 4, 0), cidrsubnet(var.vpc_cidr, 4, 1)]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 4, 8), cidrsubnet(var.vpc_cidr, 4, 9)]

  enable_nat_gateway = true
  single_nat_gateway = true # custo menor; produção real usaria um NAT por AZ

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = var.cluster_name
  # cluster_version deliberadamente omitida: deixa o módulo/AWS escolher a
  # versão suportada mais recente, evitando que a AMI padrão do node group
  # fique defasada em relação a uma versão fixada manualmente.

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }

  enable_cluster_creator_admin_permissions = true
}

# --- Publica o que os outros 3 repositórios precisam (ver ADR 0006 no repo principal) ---

resource "aws_ssm_parameter" "vpc_id" {
  name      = "/oficina/vpc_id"
  type      = "String"
  value     = module.vpc.vpc_id
  overwrite = true
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name      = "/oficina/private_subnet_ids"
  type      = "String"
  value     = join(",", module.vpc.private_subnets)
  overwrite = true
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name      = "/oficina/public_subnet_ids"
  type      = "String"
  value     = join(",", module.vpc.public_subnets)
  overwrite = true
}

resource "aws_ssm_parameter" "eks_cluster_name" {
  name      = "/oficina/eks_cluster_name"
  type      = "String"
  value     = module.eks.cluster_name
  overwrite = true
}

resource "aws_ssm_parameter" "vpc_cidr" {
  name      = "/oficina/vpc_cidr"
  type      = "String"
  value     = var.vpc_cidr
  overwrite = true
}
