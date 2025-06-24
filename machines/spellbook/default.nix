{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../modules/utils) toAttribute;

  secrets = config.sops.secrets;

  user_groups = [
    "docker"
    "keyd"
    "networkmanager"
    "wheel"
  ];
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/system/bluetooth.nix
    ../../modules/system/fonts.nix
    ../../modules/system/keyd.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nfs-client.nix
    ../../modules/system/niri.nix
    ../../modules/system/openssh.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/postgresql.nix
    ../../modules/system/settings.nix
    ../../modules/system/sops.nix
    ../../modules/system/virtualisation.nix
    ../../modules/system/xserver.nix
  ];

  config = {
    system.stateVersion = "25.05";

    machine.username = "user";
    machine.hostname = "spellbook";

    console.keyMap = "pt-latin1";
    services.xserver.xkb.layout = "pt";

    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    networking.wg-quick.interfaces.es_65.autostart = false;
    networking.wg-quick.interfaces.es_65.configFile = secrets.es_65.path;

    networking.wg-quick.interfaces.ie_36.autostart = false;
    networking.wg-quick.interfaces.ie_36.configFile = secrets.ie_36.path;

    networking.wg-quick.interfaces.uk_14.autostart = false;
    networking.wg-quick.interfaces.uk_14.configFile = secrets.uk_14.path;

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
    };

    home-manager.users.${config.machine.username} = {
      imports = [
        ../../modules/home/browser.nix
        ../../modules/home/dconf.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/ghostty.nix
        ../../modules/home/gpg.nix
        ../../modules/home/gtk.nix
        ../../modules/home/helix.nix
        ../../modules/home/keybinds.nix
        ../../modules/home/librewolf.nix
        ../../modules/home/mpv.nix
        ../../modules/home/packages.nix
        ../../modules/home/shell.nix

        (import ../../modules/home/codecs.nix { inherit config pkgs; })
        (import ../../modules/home/git.nix { inherit config pkgs; })
        (import ../../modules/home/nushell.nix { inherit config; })
        (import ../../modules/home/wayland.nix { inherit config lib pkgs; })
      ];

      home.stateVersion = "25.05";
    };

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
