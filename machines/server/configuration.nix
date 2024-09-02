{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/home.nix
    ../../modules/system.nix

    ../../packages/common.nix
  ];

  users.users."user" = {
    password = "password"; # NOTE: change after first boot
  };

  networking = {
    hostName = lib.mkForce "pi";
    firewall.allowedTCPPorts = lib.mkForce [22 80 5432];
  };

  home-manager.users.user = {
    programs = lib.mkForce {};
    gtk.enable = lib.mkForce false;
    dconf.enable = lib.mkForce false;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
