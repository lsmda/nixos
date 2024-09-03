{...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/home.nix
    ../../modules/nfs-client.nix
    ../../modules/sound.nix
    ../../modules/system.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix

    ../../packages/common.nix
    ../../packages/desktop.nix
  ];

  console.keyMap = "pt-latin1";
  services.xserver.xkb.layout = "pt";
}
