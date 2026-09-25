#!/usr/bin/env bash
# Bootstrap the Ansible controller with pure Python + Poetry (no brew/nix needed):
#   .poetry/  -> isolated venv that only contains Poetry
#   .venv/    -> project venv (ansible-core, ansible-lint) managed by Poetry
# Usage: ./bootstrap.sh            (re-runnable, idempotent)
set -euo pipefail
cd "$(dirname "$0")"

ANSIBLE_PYTHON="${ANSIBLE_PYTHON:-3.13}"
POETRY_VENV=".poetry"
# macOS system Python links LibreSSL; urllib3 warns on every Poetry call.
export PYTHONWARNINGS="ignore::Warning:urllib3"

# ansible-core 2.21 needs Python >=3.12; macOS ships 3.9, so Poetry may have to fetch a standalone CPython.
find_python() {
  local min_minor="$1" candidate
  for candidate in python3.14 python3.13 python3.12 python3.11 python3.10 python3; do
    if command -v "$candidate" >/dev/null 2>&1 &&
      "$candidate" -c "import sys; sys.exit(0 if sys.version_info >= (3, ${min_minor}) else 1)" 2>/dev/null; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

if [[ "$(uname -s)" == "Darwin" && "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" == "1" ]]; then
  echo "ERROR: this shell runs under Rosetta; open a native terminal so Homebrew picks the right prefix." >&2
  exit 1
fi

BASE_PYTHON="$(find_python 9)" || { echo "ERROR: python3 >= 3.9 is required (xcode-select --install)." >&2; exit 1; }

if [[ ! -x "$POETRY_VENV/bin/poetry" ]]; then
  "$BASE_PYTHON" -m venv "$POETRY_VENV"
  # Poetry 2.3+ dropped Python 3.9, but 2.2 still ships `poetry python install`.
  if "$BASE_PYTHON" -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)"; then
    POETRY_SPEC="poetry>=2.5,<3"
  else
    POETRY_SPEC="poetry>=2.2,<2.3"
  fi
  "$POETRY_VENV/bin/python" -m pip install --quiet --upgrade pip "$POETRY_SPEC"
fi
POETRY="$PWD/$POETRY_VENV/bin/poetry"
"$POETRY" --version

if PROJECT_PYTHON="$(find_python 12)" &&
  "$PROJECT_PYTHON" -c "import sys; sys.exit(0 if sys.version_info < (3, 15) else 1)"; then
  echo "Using local interpreter $PROJECT_PYTHON"
else
  managed_python() {
    "$POETRY" python list --managed 2>/dev/null |
      grep -E "^ *${ANSIBLE_PYTHON//./\\.}\." | grep -E '/python3 *$' |
      sed -E 's#^[^/]*(/.*python3) *$#\1#' | head -n1
  }
  PROJECT_PYTHON="$(managed_python)"
  if [[ -z "$PROJECT_PYTHON" ]]; then
    echo "No local Python 3.12-3.14 found, installing CPython ${ANSIBLE_PYTHON} via Poetry"
    "$POETRY" python install "$ANSIBLE_PYTHON"
    PROJECT_PYTHON="$(managed_python)"
  fi
  echo "Using Poetry-managed interpreter $PROJECT_PYTHON"
fi

"$POETRY" env use "$PROJECT_PYTHON"
"$POETRY" install --no-interaction
"$POETRY" run ansible-galaxy collection install -r requirements.yml -p collections

cat <<EOF

Controller ready. Next steps:
  source .venv/bin/activate
  ansible-playbook playbooks/bootstrap.yml -l <host> -K   # installs Homebrew (sudo needed once)
  ansible-playbook playbooks/site.yml -l <host>
EOF
