{...}: {
  imports = [
    ./hosts/laptop/configuration.nix
    ./hosts/laptop/hardware-configuration.nix

    ./modules/boot.nix
    ./modules/home.nix
    # ./modules/nvidia.nix
    ./modules/sound.nix
    ./modules/system.nix
    ./modules/wireguard.nix
    ./modules/xserver.nix

    ./packages/common.nix
    ./packages/desktop.nix
  ];
}
