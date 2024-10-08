{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/fish.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/nix-ld.nix
    ../../modules/sops.nix
    ../../modules/ssh.nix
    ../../modules/system.nix

    ../../options

    ../../packages/common.nix
  ];

  config =

    let
      inherit (lib) mkMerge;
    in

    mkMerge [
      {
        machine.username = "user";
        machine.hostname = "server";

        boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      }

      (import ../../modules/users.nix { inherit config pkgs; })

      (import ../../modules/home-manager.nix {
        attrs = {
          home-manager.users.${config.machine.username} = {
            programs.git = import ../../modules/git.nix { inherit config; } // {
              extraConfig = { };
            };
          };
        };
        inherit config lib;
      })
    ];
}
