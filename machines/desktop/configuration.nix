{ ... }:
let
  machine = "desktop";
in
{
  imports = [
    ./hardware-configuration.nix

    (import ../../modules/networking.nix { inherit machine; })

    ../../modules/bluetooth.nix
    ../../modules/boot.nix
    ../../modules/home.nix
    ../../modules/nfs-client.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/ssh.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  console.keyMap = "us";
  services.xserver.xkb.layout = "us";
}
