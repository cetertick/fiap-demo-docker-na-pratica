data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Preferencialmente reutiliza VPC existente do Learner Lab.
data "aws_vpc" "selected" {
  id      = var.vpc_id != "" ? var.vpc_id : null
  default = var.vpc_id == "" ? true : null
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : slice(data.aws_subnets.selected.ids, 0, 2)

  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "terragrunt-terraform"
      Purpose   = "docker-lab"
    },
    var.tags
  )
}
