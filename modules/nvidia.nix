{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.config = ''
    Section "Device"
      Identifier "nvidia"
      Driver "nvidia"
      BusID "PCI:1:0:0"
      Option "AllowEmptyInitialConfiguration"
    EndSection
  '';

  services.xserver.screenSection = ''
    Option  "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option  "AllowIndirectGLXProtocol" "off"
    Option  "TripleBuffer" "on"
  '';

  hardware.opengl.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Use pre-built CUDA binaries
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
