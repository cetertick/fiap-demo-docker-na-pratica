variable "project_name" {
  description = "Prefixo usado nos recursos AWS."
  type        = string
  default     = "docker-na-pratica"
}

variable "instance_type" {
  description = "Tipo da instancia EC2 usada no laboratorio."
  type        = string
  default     = "t3.medium"
}

variable "application_port" {
  description = "Porta publicada pela aplicacao Docker na EC2."
  type        = number
  default     = 3000
}

variable "healthcheck_path" {
  description = "Path HTTP usado pelo Target Group do ALB."
  type        = string
  default     = "/health"
}

variable "vpc_id" {
  description = "VPC existente. Se vazio, usa a VPC default da regiao."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnets publicas existentes para o ALB. Se vazio, usa subnets da VPC selecionada."
  type        = list(string)
  default     = []
}

variable "ssh_public_key_path" {
  description = "Caminho da chave publica SSH do instrutor."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR permitido para SSH na EC2. Use seu IP publico /32."
  type        = string
}

variable "http_allowed_cidr" {
  description = "CIDR permitido para acessar o ALB via HTTP."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags extras aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
