{ pkgs, ... }:

# https://wiki.nixos.org/wiki/Intel_Graphics

{
  config = {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # Enable Hardware Acceleration
        vpl-gpu-rt # Enable Quick Sync Video
      ];
    };

    services.xserver.videoDrivers = [ "modesetting" ]; # intel
  };
}
