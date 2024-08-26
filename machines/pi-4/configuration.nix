{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users."user" = {
    password = "password"; # NOTE: change after first boot
  };

  networking = {
    hostName = lib.mkDefault "pi";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  services.openssh.enable = true;

  hardware.enableRedistributableFirmware = true;
}
