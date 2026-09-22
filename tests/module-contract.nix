{
  nixpkgs,
  module,
  packages,
}:

let
  inherit (nixpkgs) lib;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  platformMessage = "services.fprintd.elanmoc2 is currently supported only on x86_64-linux";

  evaluate = targetSystem: enabled:
    lib.nixosSystem {
      system = targetSystem;
      modules = [
        module
        {
          services.fprintd.elanmoc2.enable = enabled;
          system.stateVersion = "26.05";
        }
      ];
    };

  enabled = evaluate system true;
  disabled = evaluate system false;
  unsupportedEnabled = evaluate "aarch64-linux" true;
  unsupportedDisabled = evaluate "aarch64-linux" false;

  hasFailedPlatformGuard = evaluated:
    lib.any (
      assertion:
      !assertion.assertion && assertion.message == platformMessage
    ) evaluated.config.assertions;
in
assert enabled.config.services.fprintd.enable;
assert enabled.config.services.fprintd.package.outPath == packages.fprintd-elanmoc2.outPath;
assert lib.elem packages.libfprint-elanmoc2 enabled.config.services.udev.packages;
assert !disabled.config.services.fprintd.enable;
assert disabled.config.services.fprintd.package.outPath == pkgs.fprintd.outPath;
assert !(lib.elem packages.libfprint-elanmoc2 disabled.config.services.udev.packages);
assert hasFailedPlatformGuard unsupportedEnabled;
assert !(hasFailedPlatformGuard unsupportedDisabled);
pkgs.runCommand "custom-fprintd-module-contract" { } ''
  touch "$out"
''
