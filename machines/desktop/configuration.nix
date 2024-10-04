{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/bluetooth.nix
    ../../modules/chromium.nix
    ../../modules/boot.nix
    ../../modules/fish.nix
    ../../modules/home/default.nix
    ../../modules/neovim.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/nixld.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/virtualbox.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  networking.hostName = "desktop";

  home.dconf.enable = true;
  home.git-extra.enable = true;
  home.gtk.enable = true;

  console.keyMap = "us";
  services.xserver.xkb.layout = "us";
}
