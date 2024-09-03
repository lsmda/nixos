{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/mnt/hyperx" = {
    device = "/dev/disk/by-label/HOME_NFS";
    fsType = "ext4";
    options = ["noatime" "nofail" "x-systemd.before=local-fs.target"];
  };

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = ["xhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.end0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
