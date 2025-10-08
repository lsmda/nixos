{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (import ../../utils { inherit config lib; }) createUsersGroups usersGroups;
  secrets = config.sops.secrets;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"}/nixos"

    ./hardware.nix

    ../../system/bluetooth
    ../../system/boot
    ../../system/environment
    ../../system/fonts
    ../../system/keyd
    ../../system/locale
    ../../system/networking
    ../../system/nfs-client
    ../../system/niri
    ../../system/nvidia
    ../../system/openssh
    ../../system/pipewire
    ../../system/postgresql
    ../../system/settings
    ../../system/sops
    ../../system/virtualisation
  ];

  config = {
    system.stateVersion = "25.05";

    machine.username = "user";
    machine.hostname = "thornmail";

    console.keyMap = "us";
    services.xserver.xkb.layout = "us";

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
        ../../home/dconf
        ../../home/desktop
        ../../home/fastfetch
        ../../home/ghostty
        ../../home/gpg
        ../../home/gtk
        ../../home/helix
        ../../home/mpv
        ../../home/packages
        ../../home/shell
        ../../home/vscode
        ../../home/zed

        (import ../../home/browser { inherit config pkgs; })
        (import ../../home/codecs { inherit config pkgs; })
        (import ../../home/git { inherit config pkgs; })
        (import ../../home/niri { inherit config pkgs; })
        (import ../../home/nushell { inherit config; })
        (import ../../home/ssh { inherit config pkgs; })
      ];

      dconf.settings = {
        "org/gnome/desktop/interface"."text-scaling-factor" = lib.mkForce 1.1;
      };

      home.stateVersion = "25.05";
    };

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
