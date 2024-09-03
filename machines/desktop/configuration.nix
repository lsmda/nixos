{...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/home.nix
    ../../modules/nfs-client.nix
    ../../modules/nvidia.nix
    ../../modules/sound.nix
    ../../modules/system.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  console.keyMap = "us";
  services.xserver.xkb.layout = "us";
}
