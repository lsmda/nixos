{ pkgs, ... }:

let
  interface_font = "Berkeley Mono";
in

{
  imports = [
    ./waybar/default.nix
  ];

  home.packages = with pkgs; [
    fuzzel # application launcher
    networkmanagerapplet # network manager
    swaynotificationcenter
    flameshot # screenshot tool
    wl-clipboard
  ];

  home.file.".config/fuzzel/fuzzel.ini" = {
    text = ''
      dpi-aware=no
      width=20
      line-height=40
      font=${interface_font} Md:size=14
      fields=name,categories
      icons-enabled=no
      lines=5
      horizontal-pad=30
      vertical-pad=30
      inner-pad=15
      prompt="$ "

      [colors]
      text=bbbbbbcc
      background=000000cc
      selection=444444cc
      selection-text=bbbbbbcc
      input=bbbbbbcc
      match=ffffffcc
      selection-match=ffffffcc
      prompt=bbbbbbcc

      [border]
      radius=12

      [dmenu]
      exit-immediately-if-empty=yes
    '';
  };

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
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${../assets/00.jpg}";
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

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
    style = ''
      * {
        all: unset;
        background-image: none;
      }

      window {
        background: rgba(0, 0, 0, 0.9);
      }

      button {
        font-family: ${interface_font};
        font-size: 2rem;
        background-color: rgba(50, 50, 50, 0.5);
        color: #bbb;
        border-radius: 0;
        padding: 1rem;
        margin: 0 0.5rem;
      }

      button:focus,
      button:active,
      button:hover {
        background-color: rgba(80, 80, 80, 0.5);
        border-radius: 0;
      }

      #lock {
        background-image: image(url("${../assets/icons/lock.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 100px;
      }

      #logout {
        background-image: image(url("${../assets/icons/logout.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }

      #reboot {
        background-image: image(url("${../assets/icons/reboot.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }

      #shutdown {
        background-image: image(url("${../assets/icons/shutdown.png}"));
        background-position: center;
        background-repeat: no-repeat;
        background-size: 110px;
      }
    '';
  };
}
