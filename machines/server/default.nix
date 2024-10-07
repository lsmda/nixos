{ lib, pkgs, ... }:

{
  imports = [
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/fish.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/nix-ld.nix
    ../../modules/ssh.nix
    ../../modules/system.nix

    ../../packages/common.nix
  ];

  config =
    with lib;

    let
      user = "user";
      host = "server";
    in

    mkMerge [
      {
        networking.hostName = host;
        boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      }

      (import ../../modules/users.nix { inherit pkgs user; })

      (import ../../modules/home-manager.nix {

        inherit lib user;

        cfg = {
          home-manager.users.${user} = {
            programs.git = import ../../modules/git.nix // {
              extraConfig = { };
            };
          };
        };
      })
    ];
}
