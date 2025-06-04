{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../modules/utils) keys toAttribute;
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

    ../../modules/system/caddy.nix
    ../../modules/system/fonts.nix
    ../../modules/system/keyd.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nfs-server.nix
    ../../modules/system/openssh.nix
    ../../modules/system/options.nix
    ../../modules/system/samba.nix
    ../../modules/system/settings.nix
    ../../modules/system/soft-serve.nix
    ../../modules/system/sops.nix
    ../../modules/system/virtualisation.nix
  ];

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
    shell = pkgs.nushell;
    hashedPasswordFile = secrets."password".path;
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../modules/home/bat.nix
      ../../modules/home/btop.nix
      ../../modules/home/fastfetch.nix
      ../../modules/home/gpg.nix
      ../../modules/home/helix.nix
      ../../modules/home/lazygit.nix
      ../../modules/home/packages.nix
      ../../modules/home/ranger.nix
      ../../modules/home/starship.nix

      (import ../../modules/home/git.nix { inherit config; })
      (import ../../modules/home/nushell.nix { inherit config; })
    ];

    programs.git.extraConfig = mkForce { };

    home.username = config.machine.username;
    home.homeDirectory = "/home/${config.machine.username}";

    home.stateVersion = "25.05";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
}
