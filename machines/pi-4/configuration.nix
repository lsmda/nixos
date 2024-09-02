{
  lib,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix

    ../../modules/home.nix
    ../../modules/system.nix

    ../../packages/common.nix
  ];

  users.users."user" = {
    password = "password"; # NOTE: change after first boot
  };

  networking = {
    hostName = lib.mkDefault "pi";
    firewall.allowedTCPPorts = lib.mkDefault [22 80 5432];
  };

  home-manager.users.user = {
    programs = {
      git = {
        extraConfig =
          lib.mkDefault {};
      };
    };

    gtk.enable = lib.mkDefault false;
    dconf.enable = lib.mkDefault false;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
