{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce;
  inherit (import ../../utils { inherit config pkgs; }) createUsersGroups usersGroups;
  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../system/caddy
    ../../system/fonts
    ../../system/keyd
    ../../system/kimai
    ../../system/locale
    ../../system/mysql
    ../../system/networking
    ../../system/nfs-server
    ../../system/openssh
    ../../system/postgresql
    ../../system/samba
    ../../system/settings
    ../../system/soft-serve
    ../../system/sops
    ../../system/virtualisation
  ];

  config = {
    system.stateVersion = "25.05";

    machine.username = "user";
    machine.hostname = "wardstone";

    users.groups = createUsersGroups usersGroups;

    users.users.${config.machine.username} = {
      home = "/home/${config.machine.username}";
      uid = 1000;
      isNormalUser = true;
      group = "users";
      shell = pkgs.nushell;
      hashedPasswordFile = secrets."password".path;
      extraGroups = usersGroups;
      openssh.authorizedKeys.keys = [
        config.ssh-key.frostbite
        config.ssh-key.thornmail
        config.ssh-key.spellbook
      ];
    };

    home-manager.users.${config.machine.username} = {
      imports = [
        ../../home/fastfetch
        ../../home/gpg
        ../../home/helix
        ../../home/packages
        ../../home/shell

        (import ../../home/git { inherit config pkgs; })
        (import ../../home/nushell { inherit config pkgs; })
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
