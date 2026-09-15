terraform {
  source = "../../modules/docker-lab"
}

# State local para simplificar o uso em AWS Learner Lab.
# Não versionar arquivos *.tfstate.

inputs = {
  project_name          = get_env("TG_PROJECT_NAME", "docker-na-pratica")
  instance_type         = get_env("TG_INSTANCE_TYPE", "t3.medium")
  application_port      = tonumber(get_env("TG_APPLICATION_PORT", "3000"))
  healthcheck_path      = get_env("TG_HEALTHCHECK_PATH", "/health")
  ssh_public_key_path   = get_env("SSH_PUBLIC_KEY_PATH", "${get_env("HOME")}/.ssh/id_ed25519.pub")
  ssh_allowed_cidr      = get_env("TF_VAR_ssh_allowed_cidr")
  http_allowed_cidr     = get_env("TG_HTTP_ALLOWED_CIDR", "0.0.0.0/0")

  # Opcional: defina TG_VPC_ID e TG_SUBNET_IDS quando precisar controlar a VPC/subnets.
  vpc_id     = get_env("TG_VPC_ID", "")
  subnet_ids = get_env("TG_SUBNET_IDS", "") == "" ? [] : split(",", get_env("TG_SUBNET_IDS"))

  tags = {
    Course = "Docker na Pratica"
  }
}
