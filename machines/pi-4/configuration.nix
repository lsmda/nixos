{pkgs, ...}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users."user" = {
    password = "password"; # NOTE: change after first boot
  };

  networking = {
    hostName = "pi";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [80 5432];
  };

  home-manager.users.user = {lib, ...}: {
    home.username = "user";
    home.homeDirectory = "/home/user";

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "lsmda";
        userEmail = "contact@lsmda.pm";
        extraConfig = {
          credential.credentialStore = "gpg";
          credential.helper = ["store"];
        };
      };
    };

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";

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
