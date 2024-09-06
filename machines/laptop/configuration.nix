{lib, ...}: {
  imports = [
    (import ../../modules/networking.nix {hostname = "igris";})

    ./hardware-configuration.nix

    ../../modules/bluetooth.nix
    ../../modules/boot.nix
    ../../modules/home.nix
    ../../modules/nfs-client.nix
    ../../modules/pipewire.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  home-manager.users."user" = {
    dconf.settings = {
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = lib.mkForce "medium";
      };
    };
  };

  console.keyMap = "pt-latin1";
  services.xserver.xkb.layout = "pt";
}
