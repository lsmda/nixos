{ lib, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in

{
  imports = [
    (import "${home-manager}/nixos")

    ./hardware-configuration.nix

    ../../modules/fish.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/nixld.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix

    ../../packages/common.nix
  ];

  config =

    let
      username = "user";
    in

    lib.mkMerge [
      {
        networking.hostName = "server";
        boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      }

      (import ../../modules/home-manager.nix {

        inherit lib username;

        home-manager.users.${username} = {
          programs.git = lib.attrsets.filterAttrs (n: _: n != "extraConfig") (import ../../modules/git.nix);
        };
      })
    ];
}
