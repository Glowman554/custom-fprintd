# Custom ELAN MoC2 fprintd Design

## Goal

Provide a reproducible, opt-in NixOS package and module for the ELAN
Match-on-Chip fingerprint sensor exposed as USB `04f3:0c00`, while keeping the
custom libfprint confined to fprintd rather than replacing `pkgs.libfprint`
globally.

## Architecture

- Pin Nixpkgs in a flake and override its official libfprint package.
- Fetch Depau's `elanmoc2` branch at revision
  `11f0316d069cc90c154c8cb0e46478388c5e2a74` and copy only the driver and its
  test fixtures into the official source tree.
- Apply a maintained integration patch for Meson registration, udev/hwdb data,
  storage feature semantics, and matching upstream tests.
- Rebuild the pinned Nixpkgs fprintd package against that custom libfprint.
- Expose an opt-in `services.fprintd.elanmoc2.enable` NixOS option that selects
  the custom daemon and udev data without a global overlay.

## Interfaces

The flake exports `libfprint-elanmoc2`, `fprintd-elanmoc2`, the latter as the
default package, and `nixosModules.default`. Initial support is
`x86_64-linux`.

Enabling `services.fprintd.elanmoc2.enable` enables standard NixOS fprintd and
its broad local PAM defaults. Password authentication remains available;
remote SSH authentication is outside scope.

## Driver policy

Retain all five device IDs declared by the selected driver revision:
`04f3:0c00`, `04f3:0c4c`, `04f3:0c5e`, `04f3:0c7c`, and `04f3:0c90`.
Only `04f3:0c00` is physically verified by this project initially.

Use the latest clear-storage-only behavior. Do not restore the older unreliable
per-print list/delete code, and do not patch fprintd to silently wipe the entire
sensor when deleting one user's prints.

## Delivery and verification

Document classic and flake-based NixOS consumption, safe rollout with
`nixos-rebuild test`, enrollment and verification, PAM checks, suspend/resume,
logs, rollback, and deletion recovery. GitHub Actions runs flake evaluation,
package builds, upstream test phases, and module contract checks.

License the repository under LGPL-2.1-or-later and preserve upstream notices.

