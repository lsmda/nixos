{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../utils) keys toAttribute;
  inherit (lib) mkForce;

  user_groups = [
    "docker"
    "networkmanager"
    "soft-serve"
    "wheel"
  ];

  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../system/caddy.nix
    ../../system/fonts.nix
    ../../system/keyd.nix
    ../../system/locale.nix
    ../../system/networking.nix
    ../../system/nfs-server.nix
    ../../system/openssh.nix
    ../../system/postgresql.nix
    ../../system/samba.nix
    ../../system/settings.nix
    ../../system/soft-serve.nix
    ../../system/sops.nix
    ../../system/virtualisation.nix
  ];

  config = {
    system.stateVersion = "25.05";

    machine.username = "user";
    machine.hostname = "wardstone";

    # initialize all user groups
    users.groups = lib.pipe user_groups [
      (map toAttribute)
      builtins.listToAttrs
    ];

    users.users.${config.machine.username} = {
      home = "/home/${config.machine.username}";
      uid = 1000;
      isNormalUser = true;
      group = "users";
      shell = pkgs.nushell;
      hashedPasswordFile = secrets."password".path;
      extraGroups = user_groups;
      openssh.authorizedKeys.keys = [
        keys.frostbite
        keys.thornmail
        keys.spellbook
      ];
    };

    users.users.soft-serve = {
      description = "soft-serve service user";
      isSystemUser = true;
      group = "soft-serve";
    };

    home-manager.users.${config.machine.username} = {
      imports = [
        ../../home/fastfetch.nix
        ../../home/gpg.nix
        ../../home/helix.nix
        ../../home/packages.nix
        ../../home/shell.nix

        (import ../../home/git.nix { inherit config pkgs; })
        (import ../../home/nushell.nix { inherit config; })
      ];

      programs.git.extraConfig.credential = mkForce { };

      home.username = config.machine.username;
      home.homeDirectory = "/home/${config.machine.username}";

      home.stateVersion = "25.05";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
  };
}
