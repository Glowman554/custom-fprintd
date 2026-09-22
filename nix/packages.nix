{
  fetchzip,
  fprintd,
  libfprint,
}:

let
  driverRevision = "11f0316d069cc90c154c8cb0e46478388c5e2a74";

  driverSource = fetchzip {
    url = "https://gitlab.freedesktop.org/Depau/libfprint/-/archive/${driverRevision}/libfprint-${driverRevision}.tar.gz";
    hash = "sha256-dxMls9Z5J9agesuNC46OoXAiYW/GcqWEEiAF7Y7DfwQ=";
  };

  libfprint-elanmoc2 = libfprint.overrideAttrs (old: {
    pname = "libfprint-elanmoc2";
    version = "${old.version}-elanmoc2-unstable-2025-07-27";
    __intentionallyOverridingVersion = true;

    patches = (old.patches or [ ]) ++ [ ../patches/libfprint-elanmoc2.patch ];

    postPatch = (old.postPatch or "") + ''
      cp -R --no-preserve=mode \
        ${driverSource}/libfprint/drivers/elanmoc2 \
        libfprint/drivers/elanmoc2
      cp -R --no-preserve=mode \
        ${driverSource}/tests/elanmoc2 \
        tests/elanmoc2
    '';

    meta = old.meta // {
      description = "libfprint with the experimental ELAN Match-on-Chip 2 driver";
      platforms = [ "x86_64-linux" ];
    };
  });

  fprintd-elanmoc2 = fprintd.override {
    libfprint = libfprint-elanmoc2;
  };
in
{
  inherit libfprint-elanmoc2 fprintd-elanmoc2;
}
