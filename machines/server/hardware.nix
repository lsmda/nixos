{ modulesPath, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  hardware.enableRedistributableFirmware = true;
}
