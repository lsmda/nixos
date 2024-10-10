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

    ../../modules/bluetooth.nix
    ../../modules/boot.nix
    ../../modules/chromium.nix
    ../../modules/firefox.nix
    ../../modules/fish.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/nix-ld.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/sops.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/virtualbox.nix
    ../../modules/xserver.nix

    ../../options

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  config =

    let
      inherit (lib) mkMerge readFile;
    in

    mkMerge [
      {
        machine.username = "user";
        machine.hostname = "desktop";

        console.keyMap = "us";
        services.xserver.xkb.layout = "us";
      }

      (import ../../modules/users.nix { inherit config pkgs; })

      (import ../../modules/home-manager.nix {
        attrs = {
          home-manager.users.${config.machine.username} =
            { lib, ... }:
            {
              dconf = import ../../modules/dconf.nix lib;
              gtk = import ../../modules/gtk.nix pkgs;
              programs.git = import ../../modules/git.nix;
            };
        };
        inherit config lib;
      })

      (import ../../modules/wireguard.nix {
        name = "wireguard";
        server = "185.76.11.17";
        port = 51820;
        client = "10.2.0.2/32";
        dns = "10.2.0.1";
        publicKey = readFile "/etc/wireguard/publickey";
        privateKey = "/etc/wireguard/privatekey";
      })
    ];
}
