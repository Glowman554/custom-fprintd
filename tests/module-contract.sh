#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

nix build --no-link .#checks.x86_64-linux.module-contract
printf 'module contract: enablement, package selection, udev data, and platform guard verified\n'
