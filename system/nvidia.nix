{ config, ... }:

{
  config = {
    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];

    hardware.nvidia = {
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
