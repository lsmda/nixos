{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkMerge;
  inherit (config.lan) network gateway;

  secrets = config.sops.secrets;
  background = toString ../../assets/00.jpg;

  local_routing.postUp = "ip route add ${network}/24 via ${gateway}";
  local_routing.postDown = "ip route del ${network}/24 via ${gateway}";
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
    # base system configuration with general options for the given machine.
    # attributes that don't belong to a specific module should be defined here.
    (import ../../modules/system.nix {
      machine.username = "user";
      machine.hostname = "thornmail";

      lan.network = "192.168.0.0";
      lan.gateway = "192.168.0.1";
      lan.storage = "192.168.0.5";

      console.keyMap = "us";
      services.xserver.xkb.layout = "us";

      environment.variables = {
        GSK_RENDERER = "cairo"; # fix nautilus rendering backend
      };

      services.udev.extraRules = ''
        # internal bluetooth controller is SO BAD, disabling it to keep the machine holy and pure.
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0852", ATTR{authorized}="0"
      '';

      system.stateVersion = "24.11";

      # wireguard interfaces (vpn). configuration files are kept encrypted in binary format.
      # sops-nix decrypts the corresponding files and passes them to the `configFile` attribute.
      networking.wg-quick.interfaces.es_62 = local_routing // {
        autostart = false;
        configFile = secrets.es_62.path;
      };

      networking.wg-quick.interfaces.ie_25 = local_routing // {
        autostart = false;
        configFile = secrets.ie_25.path;
      };

      networking.wg-quick.interfaces.uk_24 = local_routing // {
        autostart = true;
        configFile = secrets.uk_24.path;
      };
    })

    # at the moment there's no need for extra users so there is just one declared. in case other
    # users are needed, it's just duplicating the following block below and updating the necessary attributes.
    (import ../../modules/user.nix {
      username = config.machine.username;
      home = "/home/${config.machine.username}";
      uid = 1000;
      group = "users";
      shell = pkgs.fish;
      extraGroups = [ "docker" ];
      hashedPasswordFile = secrets."user/password".path;
    })

    # home manager configuration for user `config.machine.username`.
    # imported modules can be safely extended allowing for even greater customization.
    (import ../../home/default.nix config.machine.username {
      imports = [
        ../../home/chromium.nix
        ../../home/dconf.nix
        ../../home/firefox.nix
        ../../home/gtk.nix
        ../../home/keybinds.nix
        ../../home/packages.nix
      ];

      # extending dconf attributes.
      dconf = {
        settings."org/gnome/desktop/background".picture-uri = background;
        settings."org/gnome/desktop/background".picture-uri-dark = background;
        settings."org/gnome/desktop/screensaver".picture-uri = background;
      };

      # for some reason `sops` attribute is not appended to the config set. this makes the git
      # module not work since it depends on secrets. manually passing the config fixes the issue.
      programs = mkMerge [
        (import ../../home/mpv.nix { inherit pkgs; })
        (import ../../home/git.nix { inherit config pkgs; })
      ];

      # should be kept the same as `system.stateVersion`
      home.stateVersion = "24.11";
    })
  ];
}
