{
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ];

    boot.kernelModules = [ "kvm-amd" ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cf3307f7-9959-4dfe-b50b-bce39a767d99";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/56D0-E89A";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    hardware.cpu.amd.updateMicrocode = true;
    hardware.enableAllFirmware = true;
    hardware.graphics.enable = true; # hardware acceleration

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
