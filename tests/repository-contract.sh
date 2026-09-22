#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

test -s README.md
test -s LICENSE
test -s .github/workflows/ci.yml

yq . .github/workflows/ci.yml >/dev/null
shellcheck tests/*.sh

nix flake check --print-build-logs
nix build --no-link .#libfprint-elanmoc2 .#fprintd-elanmoc2

printf 'repository contract: docs, license, workflow, flake checks, and package builds verified\n'
