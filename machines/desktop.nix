{ pkgs, config, libs, ... }:

{
  console.keyMap = "us";
  services.xserver.xkb.layout = "us";

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
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelParams = [ "mem_sleep_default=deep" "nvidia-drm.modeset=1" ];
}
