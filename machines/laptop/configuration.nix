{lib, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/home.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/sound.nix
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
