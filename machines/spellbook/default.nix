{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../utils { inherit lib; }) createUsersGroups usersGroups;
  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../system/bluetooth.nix
    ../../system/fonts.nix
    ../../system/keyd.nix
    ../../system/locale.nix
    ../../system/networking.nix
    ../../system/nfs-client.nix
    ../../system/niri.nix
    ../../system/openssh.nix
    ../../system/pipewire.nix
    ../../system/postgresql.nix
    ../../system/settings.nix
    ../../system/sops.nix
    ../../system/virtualisation.nix
    ../../system/xserver.nix
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

    users.groups = createUsersGroups usersGroups;

    users.users.${config.machine.username} = {
      home = "/home/${config.machine.username}";
      uid = 1000;
      isNormalUser = true;
      group = "users";
      shell = pkgs.nushell;
      hashedPasswordFile = secrets."password".path;
      extraGroups = usersGroups;
    };

    home-manager.users.${config.machine.username} = {
      imports = [
        ../../home/browser.nix
        ../../home/dconf.nix
        ../../home/fastfetch.nix
        ../../home/ghostty.nix
        ../../home/gpg.nix
        ../../home/gtk.nix
        ../../home/helix.nix
        ../../home/keybinds.nix
        ../../home/mpv.nix
        ../../home/niri.nix
        ../../home/packages.nix
        ../../home/shell.nix

        (import ../../home/codecs.nix { inherit config pkgs; })
        (import ../../home/git.nix { inherit config pkgs; })
        (import ../../home/nushell.nix { inherit config; })
        (import ../../home/wayland.nix { inherit config lib pkgs; })
      ];

      home.stateVersion = "25.05";
    };

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
