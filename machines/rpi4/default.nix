{
  config,
  lib,
  pkgs,
  ...
}:

let
  secrets = config.sops.secrets;
  inherit (lib) mkMerge;
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
  ];

  config = mkMerge [
    (import ../../modules/system.nix {
      machine.username = "user";
      machine.hostname = "rpi4";

      lan.network = "192.168.0.0";

      system.stateVersion = "24.11";
      nixpkgs.config.allowUnfree = true;
    })

    # setup default user
    (import ../../modules/user.nix {
      username = config.machine.username;
      home = "/home/${config.machine.username}";
      uid = 1000;
      group = "users";
      shell = pkgs.fish;
      extraGroups = [ "docker" ];
      hashedPasswordFile = secrets."user/hashed_password".path;

      openssh.authorizedKeys.keyFiles = [
        secrets."dskt/ed_25519_pub".path
        secrets."lpt0/ed_25519_pub".path
      ];
    })

    # home-manager
    (import ../../modules/home config.machine.username {
      programs = mkMerge [
        (import ../../modules/home/git.nix { inherit config pkgs; })
        { git.extraConfig = { }; }
      ];

      home.stateVersion = "24.11";
    })
  ];
}
