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
    ../../modules/users.nix
    ../../modules/virtualbox.nix
    ../../modules/xserver.nix

    ../../options

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  config =

    let
      secrets = config.sops.secrets;
      inherit (lib) mkMerge;
    in

    mkMerge [
      {
        machine.username = "user";
        machine.hostname = "desktop";

        lan.network = "1.0.0.0";
        lan.gateway = "1.0.0.1";
        lan.server = "1.0.0.5";

        console.keyMap = "us";
        services.xserver.xkb.layout = "us";

        nixpkgs.hostPlatform = "x86_64-linux";
      }

      (import ../../modules/home-manager.nix {
        attrs = {
          home-manager.users.${config.machine.username} =
            { lib, ... }:
            {
              dconf = import ../../modules/dconf.nix { inherit config lib; };
              gtk = import ../../modules/gtk.nix { inherit pkgs; };
              programs.git = import ../../modules/git.nix;
            };
        };
        inherit config lib;
      })

      (import ../../modules/wireguard.nix {
        interface = "es_30";
        server = "185.76.11.17";
        port = 51820;
        client = "10.2.0.2/32";
        dns = "10.2.0.1";
        publicKey = "roOsz9dJeKKVt6E3EIEKXQfZsmhSfsqOceZWiuGLIgg=";
        privateKeyFile = toString secrets."wireguard/es_30/privateKey".path;
        inherit config;
      })
    ];
}
