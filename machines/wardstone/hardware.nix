{
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/mnt/hyperx" = {
    device = "/dev/disk/by-label/HOME_NFS";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
      "x-systemd.before=local-fs.target"
    ];
  };

  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
