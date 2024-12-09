{ config, ... }:

{
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.xserver.videoDrivers = [ "nvidia" ];

  # use pre-built cuda binaries
  nix.settings.substituters = [ "https://cuda-maintainers.cachix.org" ];
  nix.settings.trusted-public-keys = [
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  ];
}
