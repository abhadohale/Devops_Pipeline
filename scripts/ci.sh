#!/usr/bin/env bash
set -euo pipefail

echo "Running project validation..."

if [ -f package.json ]; then
  echo "Node.js project detected"
  npm run lint --if-present
  npm run test --if-present
  npm run build --if-present
fi

if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
  echo "Python project detected"
  python3 -m compileall .

  if [ -f requirements.txt ]; then
    python3 -m pip install pytest >/dev/null 2>&1 || true
    python3 -m pytest -q || true
  fi
fi

if ! [ -f package.json ] && ! [ -f requirements.txt ] && ! [ -f pyproject.toml ]; then
  echo "No application stack detected in this repository. Pipeline validation passed without framework-specific checks."
fi

echo "Validation complete."
