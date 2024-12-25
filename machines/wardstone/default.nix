{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkMerge;
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
  ];

  config = mkMerge [
    # base system configuration with general options for the given machine.
    # attributes that don't belong to a specific module should be defined here.
    (import ../../modules/system.nix {
      machine.username = "user";
      machine.hostname = "wardstone";

      lan.network = "192.168.0.0";

      system.stateVersion = "24.11";
    })

    # at the moment there's no need for extra users so there is just one declared. in case other
    # users are needed, it's just duplicating the following block below and updating the necessary attributes.
    (import ../../modules/user.nix {
      username = config.machine.username;
      home = "/home/${config.machine.username}";
      uid = 1000;
      group = "users";
      shell = pkgs.fish;
      extraGroups = [ "docker" ];
      hashedPasswordFile = secrets."user/password".path;

      openssh.authorizedKeys.keyFiles = [
        secrets."dskt/ed_25519_pub".path
        secrets."lpt0/ed_25519_pub".path
      ];
    })

    # home manager configuration for user `config.machine.username`.
    # imported modules can be safely extended allowing for even greater customization.
    (import ../../modules/home config.machine.username {

      # for some reason `sops` attribute is not appended to the config set. this makes the git
      # module not work since it depends on secrets. manually passing the config fixes the issue.
      programs = mkMerge [
        (import ../../modules/home/git.nix { inherit config pkgs; })
        { git.extraConfig = { }; }
      ];

      # should be kept the same as `system.stateVersion`
      home.stateVersion = "24.11";
    })
  ];
}
