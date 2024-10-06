{ lib, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in

{
  imports = [
    (import "${home-manager}/nixos")

    ./hardware-configuration.nix

    ../../modules/bluetooth.nix
    ../../modules/boot.nix
    ../../modules/chromium.nix
    ../../modules/fish.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/nixld.nix
    ../../modules/pipewire.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/virtualbox.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  config =
    with lib;

    let
      user = "user";
      host = "laptop";
    in

    mkMerge [
      {
        networking.hostName = host;
        console.keyMap = "pt-latin1";
        services.xserver.xkb.layout = "pt";
      }

      (import ../../modules/users.nix { inherit pkgs user; })

      (import ../../modules/home-manager.nix {

        inherit lib user;

        cfg = {
          home-manager.users.${user} =
            { lib, ... }:
            {
              dconf = import ../../modules/dconf.nix lib;
              gtk = import ../../modules/gtk.nix pkgs;
              programs.git = import ../../modules/git.nix;
            };
        };
      })

      (import ../../modules/wireguard.nix {
        name = "wireguard";
        server = "185.76.11.22";
        port = 51820;
        client = "10.2.0.2/32";
        dns = "10.2.0.1";
        publicKey = readFile "/etc/wireguard/publickey";
        privateKey = "/etc/wireguard/privatekey";
      })
    ];
}
