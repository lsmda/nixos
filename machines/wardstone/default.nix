{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/networking.nix
    ../../modules/nfs-server.nix
    ../../modules/options.nix
    ../../modules/samba.nix
    ../../modules/sops.nix
    ../../modules/system.nix
  ];

  machine.username = "user";
  machine.hostname = "wardstone";

  lan.network = "192.168.0.0";

  system.stateVersion = "24.11";

  users.users.${config.machine.username} = {
    home = "/home/${config.machine.username}";
    uid = 1000;
    isNormalUser = true;
    group = "users";
    shell = pkgs.fish;
    hashedPasswordFile = secrets."user/password".path;

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keyFiles = [
      secrets."dskt/ed_25519_pub".path
      secrets."lpt0/ed_25519_pub".path
    ];
  };

  home-manager.users.${config.machine.username} = {
    programs.home-manager.enable = true;

    programs.git = (import ../../home/git.nix { inherit config pkgs; }) // {
      git.extraConfig = { };
    };

    home.username = config.machine.username;
    home.homeDirectory = "/home/${config.machine.username}";

    home.stateVersion = "24.11";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
}
