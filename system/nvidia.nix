{ config, ... }:

{
  config = {
    boot.kernelModules = [
      "nvidia-drm.modeset=1" # Enable kernel modesetting for NVIDIA graphics
      "video.allow_duplicates=1" # Allow duplicate frames or similar, helps smooth video playback
    ];

    hardware.nvidia = {
      enabled = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
