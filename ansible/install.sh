#!/bin/bash
# Single entry point for a bare macOS machine: needs only the Xcode Command Line Tools (git, python3, bash 3.2).
# Prepares the Ansible virtualenv, installs Homebrew, then applies the configuration.
set -euo pipefail
cd "$(dirname "$0")"

usage() {
  cat <<EOF
Usage: $0 [options] [-- extra ansible-playbook args]

  --host HOST    inventory host (default: the host_vars entry whose home_username is $(id -un))
  --check        dry run: show what would change, no sudo needed
  --uninstall    remove what Ansible installed and restore previous files
  --setup-only   only prepare the Ansible virtualenv
  -h, --help     show this help
EOF
}

HOST=""
CHECK=0
MODE="install"
EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    --host) HOST="${2:?--host needs a value}"; shift 2 ;;
    --check) CHECK=1; shift ;;
    --uninstall) MODE="uninstall"; shift ;;
    --setup-only) MODE="setup"; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; EXTRA=("$@"); break ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if ! xcode-select -p >/dev/null 2>&1; then
  echo "ERROR: Xcode Command Line Tools missing; run 'xcode-select --install' and retry." >&2
  exit 1
fi

./bootstrap.sh
[ "$MODE" = "setup" ] && exit 0

if [ -z "$HOST" ]; then
  matches=$(grep -l -E "^home_username: *\"?$(id -un)\"? *$" inventory/host_vars/*.yml || true)
  if [ "$(printf '%s\n' "$matches" | grep -c .)" -ne 1 ]; then
    echo "ERROR: cannot guess the inventory host for user $(id -un); pass --host (see inventory/host_vars/)." >&2
    exit 1
  fi
  HOST=$(basename "$matches" .yml)
fi
echo "==> Inventory host: $HOST"

case "$(uname -m)" in
  arm64) BREW_PREFIX=/opt/homebrew ;;
  *) BREW_PREFIX=/usr/local ;;
esac

PLAYBOOK=(.venv/bin/ansible-playbook -l "$HOST")
[ "$CHECK" -eq 1 ] && PLAYBOOK+=(--check --diff)

run() {
  echo "==> ansible-playbook $*"
  "${PLAYBOOK[@]}" "$@" ${EXTRA[@]+"${EXTRA[@]}"}
}

if [ "$MODE" = "uninstall" ]; then
  # sudo is only needed to delete a Homebrew that Ansible installed.
  if [ "$CHECK" -eq 0 ] && [ -f "$HOME/.local/state/nix-configs-ansible/homebrew.txt" ]; then
    run playbooks/uninstall.yml -K
  else
    run playbooks/uninstall.yml
  fi
  exit 0
fi

# sudo is only needed once, to create the Homebrew prefix.
if [ "$CHECK" -eq 0 ] && [ ! -x "$BREW_PREFIX/bin/brew" ]; then
  run playbooks/bootstrap.yml -K
else
  run playbooks/bootstrap.yml
fi
run playbooks/site.yml

if [ "$CHECK" -eq 0 ]; then
  echo "==> Done. Open a new terminal (or: eval \"\$($BREW_PREFIX/bin/brew shellenv)\") to pick up the new PATH."
fi
