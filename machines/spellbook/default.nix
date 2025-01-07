{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkMerge;
  inherit (config.lan) network gateway;

  local_routing.postUp = "ip route add ${network}/24 via ${gateway}";
  local_routing.postDown = "ip route del ${network}/24 via ${gateway}";

  user_groups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  secrets = config.sops.secrets;
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
    ../../modules/options.nix
    ../../modules/pipewire.nix
    ../../modules/sops.nix
    ../../modules/services.nix
    ../../modules/system.nix
    ../../modules/xserver.nix
  ];

  system.stateVersion = "24.11";

  machine.username = "user";
  machine.hostname = "spellbook";

  lan.network = "192.168.0.0";
  lan.gateway = "192.168.0.1";
  lan.storage = "192.168.0.5";

  console.keyMap = "pt-latin1";
  services.xserver.xkb.layout = "pt";

  networking.wg-quick.interfaces.es_65 = local_routing // {
    autostart = true;
    configFile = secrets.es_65.path;
  };

  networking.wg-quick.interfaces.ie_36 = local_routing // {
    autostart = false;
    configFile = secrets.ie_36.path;
  };

  networking.wg-quick.interfaces.uk_14 = local_routing // {
    autostart = false;
    configFile = secrets.uk_14.path;
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
    extraGroups = user_groups;
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../home/chromium.nix
      ../../home/dconf.nix
      ../../home/dunst.nix
      ../../home/fastfetch.nix
      ../../home/firefox.nix
      ../../home/fish.nix
      ../../home/gtk.nix
      ../../home/hyprland.nix
      ../../home/keybinds.nix
      ../../home/mpv.nix
      ../../home/packages.nix
      ../../home/rofi.nix
      ../../home/waybar.nix
    ];

    programs = mkMerge [
      (import ../../home/git.nix { inherit config pkgs; })
      (import ../../home/kitty.nix { inherit config; })
    ];

    # extend wayland config
    wayland.windowManager.hyprland.settings.input.kb_layout = "pt";

    home.pointerCursor.gtk.enable = true;
    home.pointerCursor.name = "BreezeX-RosePineDawn-Linux";
    home.pointerCursor.package = pkgs.rose-pine-cursor;
    home.pointerCursor.size = 20;

    home.stateVersion = "24.11";
  };

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
