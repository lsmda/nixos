{
  config,
  lib,
  pkgs,
  ...
}:

let
  background = "file:///home/user/dotfiles/wallpapers/background.jpg";
  local_routing = {
    postUp = "ip route add ${config.lan.network}/24 via ${config.lan.gateway}";
    postDown = "ip route del ${config.lan.network}/24 via ${config.lan.gateway}";
  };
  secrets = config.sops.secrets;
  inherit (lib) mkMerge;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/bluetooth.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/nvidia.nix
    ../../modules/options.nix
    ../../modules/pipewire.nix
    ../../modules/sops.nix
    ../../modules/xserver.nix
  ];

  config = mkMerge [
    (import ../../modules/system.nix {
      machine.username = "user";
      machine.hostname = "dskt";

      lan.network = "192.168.0.0";
      lan.gateway = "192.168.0.1";
      lan.storage = "192.168.0.5";

      console.keyMap = "us";
      services.xserver.xkb.layout = "us";

      networking.wg-quick.interfaces.es_62 = local_routing // {
        autostart = false;
        configFile = secrets.es_62.path;
      };

      networking.wg-quick.interfaces.ie_25 = local_routing // {
        autostart = false;
        configFile = secrets.ie_25.path;
      };

      networking.wg-quick.interfaces.uk_24 = local_routing // {
        configFile = secrets.uk_24.path;
      };

      environment.variables = {
        GSK_RENDERER = "cairo"; # fix nautilus rendering backend
      };

      services.udev.extraRules = ''
        # disable internal bluetooth controller
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0852", ATTR{authorized}="0"
      '';

      # virtual box
      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ "user" ];

      system.stateVersion = "24.11";
      nixpkgs.config.allowUnfree = true;
    })

    # setup default user
    (import ../../modules/user.nix {
      username = config.machine.username;
      home = "/home/${config.machine.username}";
      uid = 1000;
      group = "users";
      shell = pkgs.fish;
      extraGroups = [ "docker" ];
      hashedPasswordFile = secrets."user/hashed_password".path;
    })

    # home-manager
    (import ../../home/default.nix config.machine.username {
      imports = [
        ../../home/chromium.nix
        ../../home/dconf.nix
        ../../home/firefox.nix
        ../../home/gtk.nix
        ../../home/keybinds.nix
        ../../home/packages.nix
      ];

      # extend dconf module
      dconf = {
        settings."org/gnome/desktop/background".picture-uri = background;
        settings."org/gnome/desktop/background".picture-uri-dark = background;
        settings."org/gnome/desktop/screensaver".picture-uri = background;
      };

      programs = mkMerge [
        (import ../../modules/home/mpv.nix { inherit pkgs; })
        (import ../../modules/home/git.nix { inherit config pkgs; })
      ];

      home.stateVersion = "24.11";
    })
  ];
}
