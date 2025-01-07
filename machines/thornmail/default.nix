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
    ../../modules/nvidia.nix
    ../../modules/options.nix
    ../../modules/pipewire.nix
    ../../modules/sops.nix
    ../../modules/services.nix
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

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  programs.xwayland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
  ];

  environment.variables = {
    GSK_RENDERER = "cairo"; # fix nautilus rendering backend
    NIXOS_OZONE_WL = "1"; # use wayland
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

    home.file.".imwheelrc".source = ../../home/config/.imwheelrc;
    home.file.".config/autostart/imwheel.desktop".source = ../../home/config/imwheel.desktop;

    # extend wayland config
    wayland.windowManager.hyprland.settings.input.kb_layout = "us";

    home.pointerCursor.gtk.enable = true;
    home.pointerCursor.name = "BreezeX-RosePineDawn-Linux";
    home.pointerCursor.package = pkgs.rose-pine-cursor;
    home.pointerCursor.size = 18;

    home.stateVersion = "24.11";
  };

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
