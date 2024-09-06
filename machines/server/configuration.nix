{
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ../../modules/networking.nix {hostname = "server";})

    ./hardware-configuration.nix

    ../../modules/home.nix
    ../../modules/nfs-server.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix

    ../../packages/common.nix
  ];

  home-manager.users.user = {
    programs = lib.mkForce {};
    gtk.enable = lib.mkForce false;
    dconf.enable = lib.mkForce false;
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
