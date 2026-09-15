#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
IP="$(output_value instance_public_ip)"
ALB_URL="$(output_value alb_url)"
TG_ARN="$(output_value target_group_arn)"

log "Subindo container temporário na EC2 para validar ALB -> EC2 -> Docker..."
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=accept-new "$REMOTE_USER@$IP" bash -s <<'REMOTE'
set -euo pipefail
docker rm -f alb-smoke >/dev/null 2>&1 || true
docker run -d --name alb-smoke -p 3000:80 nginx:alpine >/dev/null
sleep 2
docker exec alb-smoke sh -c 'echo ok > /usr/share/nginx/html/health'
curl -fsS http://localhost:3000/health
REMOTE

log "Aguardando Target Group ficar healthy..."
for i in {1..24}; do
  STATE="$(aws elbv2 describe-target-health --target-group-arn "$TG_ARN" --query 'TargetHealthDescriptions[0].TargetHealth.State' --output text 2>/dev/null || true)"
  log "Target state: ${STATE:-unknown}"
  if [[ "$STATE" == "healthy" ]]; then break; fi
  sleep 5
done

log "Testando ALB: $ALB_URL/health"
curl -fsS "$ALB_URL/health"

log "Removendo container temporário..."
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=accept-new "$REMOTE_USER@$IP" "docker rm -f alb-smoke >/dev/null 2>&1 || true"
log "Smoke test concluído."
