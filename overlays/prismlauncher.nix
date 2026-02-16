{
  config.flake.overlays = {
    prismlauncher = (self: super: {
      prismlauncher-unwrapped = super.prismlauncher-unwrapped.overrideAttrs (oa: {
        patches = (oa.patches or []) ++ [
          (super.fetchpatch2 {
            name = "online-is-offline";
            url = "https://github.com/PrismLauncher/PrismLauncher/commit/911c0f3593dd6b825f6d91900e48bdf3b59ad3a9.patch";
            hash = "sha256-3Tn+yl0n9nPEsghWeqW7Ov6GuSGbuKvVEFtVw44nZuY=";
          })
          (super.fetchpatch2 {
            name = "unlock-non-premium-account";
            url = "https://github.com/PrismLauncher/PrismLauncher/commit/12acabdb57ba6f12fcf9047c28ec8afa7a4fb970.patch";
            hash = "sha256-7gjHP4SAIwyMR67pRKSl7e54pMvr2BGWl8Olc28IxAY=";
          })
        ];
      });
    });
  };
}
