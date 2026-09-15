#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TG_DIR="$ROOT_DIR/infra/live/learner-lab"
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_ed25519}"
REMOTE_USER="${REMOTE_USER:-ubuntu}"
REMOTE_DIR="${REMOTE_DIR:-/home/ubuntu/docker-na-pratica}"

log() { printf '\033[1;36m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m[ERRO]\033[0m %s\n' "$*" >&2; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Comando obrigatório não encontrado: $1"; exit 1; }
}

require_aws_env() {
  : "${AWS_ACCESS_KEY_ID:?Defina AWS_ACCESS_KEY_ID}"
  : "${AWS_SECRET_ACCESS_KEY:?Defina AWS_SECRET_ACCESS_KEY}"
  : "${AWS_SESSION_TOKEN:?Defina AWS_SESSION_TOKEN do Learner Lab}"
  : "${AWS_REGION:?Defina AWS_REGION}"
  export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-$AWS_REGION}"
}

tg() {
  (cd "$TG_DIR" && terragrunt "$@")
}

tg_run_all() {
  # Compatibilidade com Terragrunt novo e legado.
  if terragrunt run --help >/dev/null 2>&1; then
    (cd "$TG_DIR" && terragrunt run --all "$@")
  else
    (cd "$TG_DIR" && terragrunt run-all "$@")
  fi
}

json_output() {
  tg output -json
}

output_value() {
  local key="$1"
  json_output | jq -r ".${key}.value"
}
