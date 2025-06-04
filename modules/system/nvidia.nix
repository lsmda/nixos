{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.nvidia_x11
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
