{ config, ... }:

let
  # https://yalter.github.io/niri/Nvidia.html#high-vram-usage-fix
  limitFreeBufferPool = builtins.toJSON {
    rules = [
      {
        pattern = {
          feature = "procname";
          matches = "niri";
        };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
    ];
    profiles = [
      {
        name = "Limit Free Buffer Pool On Wayland Compositors";
        settings = [
          {
            key = "GLVidHeapReuseRatio";
            value = 0;
          }
        ];
      }
    ];
  };
in

{
  config = {
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "video.allow_duplicates=1" # Allow duplicate frames, helps smooth video playback
    ];

    environment.etc = {
      "nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool".text = limitFreeBufferPool;
    };

    environment.variables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
