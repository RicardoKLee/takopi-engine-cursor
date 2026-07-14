#!/usr/bin/env bash
set -euo pipefail

# Configure GitHub `pypi` environments and print PyPI Trusted Publisher URLs.
# PyPI publisher registration must be done in the browser (no public API).

OWNER="${GITHUB_OWNER:-RicardoKLee}"
PACKAGES=(
  "takopi-engine-cursor"
  "takopi-engine-qoder"
  "takopi-transport-feishu"
)

token="${GH_TOKEN:-${GITHUB_TOKEN:-}}"
if [[ -z "$token" ]] && [[ -f "${HOME}/.config/gh/hosts.yml" ]]; then
  token="$(python3 - <<'PY'
import re
from pathlib import Path
text = Path.home().joinpath(".config/gh/hosts.yml").read_text()
match = re.search(r"oauth_token:\s*(\S+)", text)
print(match.group(1) if match else "")
PY
)"
fi

if [[ -z "$token" ]]; then
  echo "Set GH_TOKEN or run gh auth login first." >&2
  exit 1
fi

echo "Creating GitHub environment 'pypi' for each plugin repo..."
for repo in "${PACKAGES[@]}"; do
  echo "  -> ${OWNER}/${repo}"
  curl -fsS -X PUT \
    -H "Authorization: Bearer ${token}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${OWNER}/${repo}/environments/pypi" \
    -d '{"deployment_branch_policy":null}' >/dev/null
done

echo
echo "GitHub environments ready."
echo
echo "Next: register Trusted Publishers on PyPI (one-time, browser):"
echo
for pkg in "${PACKAGES[@]}"; do
  cat <<EOF
  ${pkg}
    PyPI:  https://pypi.org/manage/project/${pkg}/settings/publishing/
    Owner: ${OWNER}
    Repository: ${pkg}
    Workflow: publish.yml
    Environment: pypi

EOF
done

echo "After PyPI setup, release with:"
echo "  1. bump version in pyproject.toml"
echo "  2. git tag vX.Y.Z && git push origin vX.Y.Z"
echo
echo "Or dry-run the workflow:"
echo "  gh workflow run publish.yml -R ${OWNER}/takopi-engine-cursor"
