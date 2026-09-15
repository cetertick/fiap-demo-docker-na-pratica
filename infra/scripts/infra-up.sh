#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
log "Criando infraestrutura com Terragrunt..."
tg_run_all apply -auto-approve
log "Outputs:"
tg output
