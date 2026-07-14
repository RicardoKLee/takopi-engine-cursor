#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${UV_PUBLISH_TOKEN:-}" ]]; then
  echo "Set UV_PUBLISH_TOKEN to a PyPI API token first." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGES=(
  takopi-engine-cursor
  takopi-engine-qoder
  takopi-transport-feishu
)

for pkg in "${PACKAGES[@]}"; do
  echo "===== $pkg ====="
  cd "$ROOT/$pkg"
  rm -rf dist
  uv build
  uv publish
  echo
done

echo "Done. Verify:"
for pkg in "${PACKAGES[@]}"; do
  echo "  https://pypi.org/project/${pkg}/"
done
