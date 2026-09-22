# Custom ELAN MoC2 fprintd Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and document a reproducible custom fprintd package for the ELAN `04f3:0c00` sensor on NixOS.

**Architecture:** Graft Depau's pinned `elanmoc2` driver onto the flake-pinned official libfprint package, rebuild fprintd against it, and activate it through a scoped NixOS module. Keep the base Nixpkgs input independent from consumers because the integration patch is validated against that exact source revision.

**Tech Stack:** Nix flakes, NixOS modules, Meson/C upstream sources, Bash contract tests, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-09-22-custom-fprintd-design.md`

## Global Constraints

- Initial platform: `x86_64-linux`.
- Driver revision: `11f0316d069cc90c154c8cb0e46478388c5e2a74`.
- Driver source hash: `sha256-dxMls9Z5J9agesuNC46OoXAiYW/GcqWEEiAF7Y7DfwQ=`.
- No global Nixpkgs overlay and no proprietary TOD driver.
- Preserve clear-storage-only deletion semantics.
- Repository license: LGPL-2.1-or-later.

## Review Focus

- A missing device ID must fail the built-artifact contract test.
- Enabling the module must select both the custom fprintd and custom udev data.
- Importing the disabled module must leave upstream fprintd configuration unchanged.
- Unsupported systems must produce a clear assertion only when the module is enabled.
- Updating Nixpkgs must fail loudly when the integration patch no longer applies.

---

### Task 1: Reproducible packages

**Files:** Create the package contract test, flake, package expression, and tracked integration patch.

**Interfaces:** Produces `libfprint-elanmoc2`, `fprintd-elanmoc2`, and the default package for later module use.

- [ ] Write and run the package contract test; confirm it fails because the flake outputs do not exist.
- [ ] Implement the pinned driver fetch, scoped libfprint override, integration patch, and fprintd override.
- [ ] Build both packages and run the package contract to green.
- [ ] Commit the package slice.

### Task 2: NixOS module and flake checks

**Files:** Create the module and module evaluation contract, then expose them from the flake.

**Interfaces:** Consumes both Task 1 packages and produces `nixosModules.default` plus flake checks.

- [ ] Write and run module evaluation contracts; confirm they fail before the module exists.
- [ ] Implement `services.fprintd.elanmoc2.enable`, x86_64 guarding, package selection, and udev integration.
- [ ] Run module contracts and `nix flake check` to green.
- [ ] Commit the module slice.

### Task 3: User documentation, licensing, and CI

**Files:** Create README, LGPL license, and GitHub Actions workflow.

**Interfaces:** Documents both classic and flake consumers and automates the complete verification command.

- [ ] Add a CI/repository contract and observe it fail for missing delivery files.
- [ ] Add installation, testing, recovery, limitation, attribution, and CI material.
- [ ] Run the repository contract, full flake checks, and both explicit package builds.
- [ ] Commit the delivery slice.

