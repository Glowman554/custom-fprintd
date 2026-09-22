{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fprintd.elanmoc2;
  system = pkgs.stdenv.hostPlatform.system;
  supported = system == "x86_64-linux";
  customPackages = if supported then self.packages.${system} else null;
in
{
  options.services.fprintd.elanmoc2.enable = lib.mkEnableOption ''
    the experimental ELAN Match-on-Chip 2 driver through the scoped custom
    fprintd package
  '';

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = supported;
        message = "services.fprintd.elanmoc2 is currently supported only on x86_64-linux";
      }
    ];

    services.fprintd = {
      enable = true;
      package = if supported then customPackages.fprintd-elanmoc2 else pkgs.fprintd;
    };

    services.udev.packages = lib.optionals supported [ customPackages.libfprint-elanmoc2 ];
  };
}
