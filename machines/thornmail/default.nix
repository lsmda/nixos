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

  user_groups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  to_attribute = (import ../../utils).to_attribute;
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
    ../../modules/system.nix
    ../../modules/wireguard.nix
    ../../modules/xserver.nix
  ];

  system.stateVersion = "24.11";

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

  users.groups = lib.pipe user_groups [
    (map to_attribute)
    builtins.listToAttrs
  ];

  users.users.${config.machine.username} = {
    home = "/home/${config.machine.username}";
    uid = 1000;
    isNormalUser = true;
    group = "users";
    shell = pkgs.fish;
    hashedPasswordFile = secrets."user/password".path;

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../home/chromium.nix
      ../../home/dconf.nix
      ../../home/firefox.nix
      ../../home/gtk.nix
      ../../home/keybinds.nix
      ../../home/packages.nix
    ];

    home.file.".imwheelrc".source = ../../home/config/.imwheelrc;
    home.file.".Xresources".source = ../../home/config/.Xresources;
    home.file.".config/autostart/imwheel.desktop".source = ../../home/config/imwheel.desktop;
    home.file.".config/redshift.conf".source = ../../home/config/redshift.conf;

    dconf = {
      settings."org/gnome/desktop/background".picture-uri = background;
      settings."org/gnome/desktop/background".picture-uri-dark = background;
      settings."org/gnome/desktop/screensaver".picture-uri = background;
    };

    programs = mkMerge [
      (import ../../home/mpv.nix { inherit pkgs; })
      (import ../../home/git.nix { inherit config pkgs; })
    ];

    home.stateVersion = "24.11";
  };

  home-manager.backupFileExtension = "backup";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

}
