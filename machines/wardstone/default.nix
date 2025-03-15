{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../utils) to_attribute;
  inherit (lib) mkForce;

  user_groups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  secrets = config.sops.secrets;
  templates = config.sops.templates;
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

  system.stateVersion = "24.11";

  machine.username = "user";
  machine.hostname = "wardstone";

  lan.network = "192.168.0.0";

  users.groups = lib.pipe user_groups [
    (map to_attribute)
    builtins.listToAttrs
  ];

  users.users.${config.machine.username} = {
    home = "/home/${config.machine.username}";
    uid = 1000;
    isNormalUser = true;
    group = "users";
    shell = pkgs.nushell;
    hashedPasswordFile = secrets."user/password".path;
    extraGroups = user_groups;
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../home/fastfetch.nix
      ../../home/packages.nix

      (import ../../home/git.nix { inherit config; })
      (import ../../home/nushell.nix { inherit config; })
    ];

    programs.git.extraConfig = mkForce { };

    home.username = config.machine.username;
    home.homeDirectory = "/home/${config.machine.username}";

    home.stateVersion = "24.11";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
}
