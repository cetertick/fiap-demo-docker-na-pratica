#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "Validando ferramentas locais..."
for c in aws terraform terragrunt jq curl ssh scp; do need_cmd "$c"; done

log "Validando credenciais AWS temporárias..."
require_aws_env
aws sts get-caller-identity >/tmp/docker-lab-sts.json
cat /tmp/docker-lab-sts.json | jq .

log "Validando chave SSH..."
PUB_KEY="${SSH_PUBLIC_KEY_PATH:-$HOME/.ssh/id_ed25519.pub}"
if [[ ! -f "$PUB_KEY" ]]; then
  err "Chave pública não encontrada em $PUB_KEY"
  err "Crie com: ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519"
  exit 1
fi

if [[ -z "${TF_VAR_ssh_allowed_cidr:-}" ]]; then
  warn "TF_VAR_ssh_allowed_cidr não está definido."
  warn "Sugestão: export TF_VAR_ssh_allowed_cidr=\"$(curl -fsS https://checkip.amazonaws.com 2>/dev/null || echo SEU_IP)/32\""
  exit 1
fi

log "Validando VPC e subnets..."
VPC_ID="${TG_VPC_ID:-}"
if [[ -z "$VPC_ID" ]]; then
  VPC_ID="$(aws ec2 describe-vpcs --filters Name=is-default,Values=true --query 'Vpcs[0].VpcId' --output text)"
fi
if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
  err "Nenhuma VPC default encontrada. Defina TG_VPC_ID."
  exit 1
fi
log "VPC selecionada: $VPC_ID"

SUBNET_COUNT="$(aws ec2 describe-subnets --filters Name=vpc-id,Values="$VPC_ID" --query 'length(Subnets)' --output text)"
if [[ "$SUBNET_COUNT" -lt 2 ]]; then
  err "ALB precisa de pelo menos 2 subnets. Encontradas: $SUBNET_COUNT"
  exit 1
fi
log "Subnets encontradas: $SUBNET_COUNT"

log "Preflight concluído."
