{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/2dc9266f-c7c9-4320-a9c5-2856cb9793b5";
    label = "ssd";
    fsType = "ext4";
    options = [
      "users" # allow any user to mount and to unmount the filesystem
      "nofail" # do not report errors for this device if it does not exist
      "x-gvfs-show" # make mounted filesystem visible in file explorer
    ];
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/5db59a5a-b4b7-4ef6-a96c-07ee1d8d4c60";
    label = "hdd";
    fsType = "ext4";
    options = [
      "users" # allow any user to mount and to unmount the filesystem
      "nofail" # do not report errors for this device if it does not exist
      "x-gvfs-show" # make mounted filesystem visible in file explorer
    ];
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];
}
