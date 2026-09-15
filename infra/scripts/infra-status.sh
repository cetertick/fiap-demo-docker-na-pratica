#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
log "Outputs Terragrunt:"
tg output
TG_ARN="$(output_value target_group_arn)"
log "Health do Target Group:"
aws elbv2 describe-target-health --target-group-arn "$TG_ARN" | jq .
