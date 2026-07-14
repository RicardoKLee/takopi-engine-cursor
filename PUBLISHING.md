# Publishing to PyPI

## Automatic releases (recommended)

Push a tag that matches `pyproject.toml` version:

```sh
# edit pyproject.toml -> version = "0.2.1"
git commit -am "chore: release v0.2.1"
git tag v0.2.1
git push origin master --tags
```

GitHub Actions (`publish.yml`) will:

1. verify tag vs `pyproject.toml`
2. run tests
3. build wheel + sdist
4. publish to PyPI via **Trusted Publishing**
5. create a GitHub Release with artifacts

### One-time setup

Run once from this repo:

```sh
bash scripts/setup-trusted-publishing.sh
```

That creates the GitHub `pypi` environment on all three plugin repos.

Then register **Trusted Publisher** on PyPI for each existing project:

| PyPI project | Settings URL |
|--------------|--------------|
| `takopi-engine-cursor` | https://pypi.org/manage/project/takopi-engine-cursor/settings/publishing/ |
| `takopi-engine-qoder` | https://pypi.org/manage/project/takopi-engine-qoder/settings/publishing/ |
| `takopi-transport-feishu` | https://pypi.org/manage/project/takopi-transport-feishu/settings/publishing/ |

For each project, click **Add a new publisher** → **GitHub Actions** and fill:

| Field | Value |
|-------|-------|
| Owner | `RicardoKLee` |
| Repository | same as PyPI project name |
| Workflow name | `publish.yml` |
| Environment name | `pypi` |

Manual test without a tag:

```sh
gh workflow run publish.yml -R RicardoKLee/takopi-engine-cursor
```

## Manual upload (API token)

```sh
export UV_PUBLISH_TOKEN='pypi-...'
bash scripts/publish-all.sh
```

Only use this for bootstrapping or emergencies. Prefer Trusted Publishing for CI.
