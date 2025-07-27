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
    ../../system/nvidia.nix
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
    machine.hostname = "thornmail";

    console.keyMap = "us";
    services.xserver.xkb.layout = "us";

    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    services.udev.extraRules = ''
      # internal bluetooth controller is SO BAD, disabling it to keep the machine holy and pure.
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0852", ATTR{authorized}="0"
    '';

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
        ../../home/packages.nix
        ../../home/shell.nix
        ../../home/zed.nix

        (import ../../home/codecs.nix { inherit config pkgs; })
        (import ../../home/git.nix { inherit config pkgs; })
        (import ../../home/nushell.nix { inherit config; })
      ];

      home.stateVersion = "25.05";
    };

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
