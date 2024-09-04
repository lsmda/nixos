{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/home.nix
    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix

    ../../packages/common.nix
  ];

  networking.hostName = lib.mkForce "pi";

  home-manager.users.user = {
    programs = lib.mkForce {};
    gtk.enable = lib.mkForce false;
    dconf.enable = lib.mkForce false;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
