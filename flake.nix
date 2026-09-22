{
  description = "Experimental ELAN Match-on-Chip 2 support for fprintd on NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      customPackages = pkgs.callPackage ./nix/packages.nix { };
    in
    {
      packages.${system} = {
        inherit (customPackages) libfprint-elanmoc2 fprintd-elanmoc2;
        default = customPackages.fprintd-elanmoc2;
      };
    };
}
