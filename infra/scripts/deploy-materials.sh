#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_aws_env
need_cmd rsync
IP="$(output_value instance_public_ip)"
log "Copiando materiais para $REMOTE_USER@$IP:$REMOTE_DIR"
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=accept-new "$REMOTE_USER@$IP" "mkdir -p '$REMOTE_DIR'"
rsync -avz --delete -e "ssh -i $SSH_KEY_PATH -o StrictHostKeyChecking=accept-new" \
  "$ROOT_DIR/app" \
  "$ROOT_DIR/lab" \
  "$REMOTE_USER@$IP:$REMOTE_DIR/"
log "Materiais copiados."
log "Acesso: ssh -i $SSH_KEY_PATH $REMOTE_USER@$IP"
