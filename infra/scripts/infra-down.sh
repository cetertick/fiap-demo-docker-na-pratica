#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
read -r -p "Confirma destruir a infraestrutura do laboratório? Digite DESTROY: " CONFIRM
if [[ "$CONFIRM" != "DESTROY" ]]; then
  err "Operação cancelada."
  exit 1
fi
log "Destruindo infraestrutura com Terragrunt..."
tg_run_all destroy -auto-approve
