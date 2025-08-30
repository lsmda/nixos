{
  config = {
    boot = {
      initrd.systemd.enable = true;
      initrd.verbose = false;

      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.enable = true;
      loader.systemd-boot.configurationLimit = 3;

      plymouth.enable = true;
      plymouth.theme = "breeze";

      tmp.cleanOnBoot = true;
    };
  };
}
