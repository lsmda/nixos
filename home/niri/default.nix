{ config, pkgs, ... }:

let
  default = builtins.readFile ./configuration/default.kdl;
  hostname = builtins.readFile ./configuration/${config.machine.hostname}.kdl;
  inherit (pkgs) lib;
in

{
  imports = [
    ../fuzzel.nix
    ../waybar
    ../wlogout.nix
  ];

  config = {
    home.packages = with pkgs; [
      flameshot # screenshot tool
      libnotify # notify-send
      networkmanagerapplet # network manager
      swaynotificationcenter
      wl-clipboard
    ];

    home.file.".config/niri/config.kdl".text = lib.strings.concatStringsSep "" [
      default
      hostname
    ];

    services.swayosd = {
      enable = true;
    };

    systemd.user.services.swaybg = {
      Unit = {
        Description = "Wallpaper tool for Wayland compositors";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${../../assets/00.jpg}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "niri.service" ];
    };

    systemd.user.services.wlsunset = {
      Unit = {
        Description = "Day/night gamma adjustments for Wayland";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        ExecStart = "${pkgs.wlsunset}/bin/wlsunset -l 37.2 -L -8.4 -t 3500 -T 3600";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "niri.service" ];
    };

    systemd.user.services.xwayland-satellite = {
      Unit = {
        Description = "Xwayland outside your Wayland";
        BindsTo = "graphical-session.target";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = "${pkgs.writeShellScript "xwayland-satellite" ''
          "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
        ''}";
        StandardOutput = "journal";
      };
      Install.WantedBy = [ "niri.service" ];
    };
  };
}
