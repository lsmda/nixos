{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../utils) to_attribute;
  inherit (lib) mkForce;
  inherit (config.lan) network gateway;

  local_routing.postUp = "ip route add ${network}/24 via ${gateway}";
  local_routing.postDown = "ip route del ${network}/24 via ${gateway}";

  user_groups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  secrets = config.sops.secrets;
  background = toString ../../assets/00.jpg;
in

{
  imports = [
    "${fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops"
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"}/nixos"

    ./hardware.nix

    ../../modules/bluetooth.nix
    ../../modules/keyboard.nix
    ../../modules/networking.nix
    ../../modules/nfs-client.nix
    ../../modules/options.nix
    ../../modules/pipewire.nix
    ../../modules/sops.nix
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

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  networking.wg-quick.interfaces.es_65 = local_routing // {
    autostart = false;
    configFile = secrets.es_65.path;
  };

  networking.wg-quick.interfaces.ie_36 = local_routing // {
    autostart = true;
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
    shell = pkgs.nushell;
    hashedPasswordFile = secrets."user/password".path;
    extraGroups = user_groups;
  };

  home-manager.users.${config.machine.username} = {
    imports = [
      ../../home/btop.nix
      ../../home/chromium.nix
      ../../home/dconf.nix
      ../../home/docker.nix
      ../../home/fastfetch.nix
      ../../home/ghostty.nix
      ../../home/gpg.nix
      ../../home/gtk.nix
      ../../home/helix.nix
      ../../home/lazygit.nix
      ../../home/keybinds.nix
      ../../home/mpv.nix
      ../../home/packages.nix
      ../../home/ranger.nix

      (import ../../home/git.nix { inherit config; })
      (import ../../home/nushell.nix { inherit config; })
    ];

    dconf = {
      settings."org/gnome/desktop/background".picture-uri = background;
      settings."org/gnome/desktop/background".picture-uri-dark = background;
      settings."org/gnome/desktop/interface".text-scaling-factor = mkForce 0.8;
      settings."org/gnome/desktop/screensaver".picture-uri = background;
      settings."org/gnome/nautilus/icon-view".default-zoom-level = mkForce "medium";
    };

    home.stateVersion = "24.11";
  };

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
