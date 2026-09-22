#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

libfprint_out=$(nix build --no-link --print-out-paths .#libfprint-elanmoc2)
fprintd_out=$(nix build --no-link --print-out-paths .#fprintd-elanmoc2)
default_out=$(nix build --no-link --print-out-paths .#default)

hwdb="$libfprint_out/lib/udev/hwdb.d/60-autosuspend-libfprint-2.hwdb"
test -f "$hwdb"

for product_id in 0C00 0C4C 0C5E 0C7C 0C90; do
  grep -Fqx "usb:v04F3p${product_id}*" "$hwdb"
done

test "$default_out" = "$fprintd_out"
nix-store --query --references "$fprintd_out" | grep -Fq "$libfprint_out"
