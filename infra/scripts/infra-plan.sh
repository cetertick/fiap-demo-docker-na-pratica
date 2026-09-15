#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
log "Executando terragrunt plan..."
tg_run_all plan
