{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/fish.nix
    ../../modules/home/default.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/nixld.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix

    ../../packages/common.nix
  ];

  networking.hostName = "server";

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
