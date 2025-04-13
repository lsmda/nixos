{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../modules/utils) to_attribute;
  inherit (lib) mkForce;

  user_groups = [
    "docker"
    "networkmanager"
    "wheel"
  ];

  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/system/keyd.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nfs-server.nix
    ../../modules/system/options.nix
    ../../modules/system/samba.nix
    ../../modules/system/sops.nix
    ../../modules/system/systemd.nix
  ];

  system.stateVersion = "24.11";

  machine.username = "user";
  machine.hostname = "wardstone";

  lan.network = "192.168.0.0";

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

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
    hashedPasswordFile = secrets."password".path;
    extraGroups = user_groups;
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../modules/home/btop.nix
      ../../modules/home/docker.nix
      ../../modules/home/fastfetch.nix
      ../../modules/home/gpg.nix
      ../../modules/home/helix.nix
      ../../modules/home/lazygit.nix
      ../../modules/home/packages.nix
      ../../modules/home/ranger.nix
      ../../modules/home/starship.nix

      (import ../../modules/home/git.nix { inherit config; })
      (import ../../modules/home/nushell.nix { inherit config; })
      (import ../../modules/home/soft-serve.nix { inherit config pkgs; })
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
