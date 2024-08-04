{ pkgs, config, libs, ... }:

{
  console.keyMap = "us";
  services.xserver.xkb.layout = "us";

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.forceFullCompositionPipeline = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
}
