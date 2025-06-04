{
  config,
  lib,
  pkgs,
  ...
}:

let
  interface_font = "Open Sans";
  hostname = config.machine.hostname;
in

{
  home.packages = with pkgs; [
    fuzzel # application launcher
    swaybg # background
    swaylock # lock screen
    xwayland-satellite # x11 support
    xdg-desktop-portal-gnome # screen sharing
    xdg-utils
    networkmanagerapplet # network manager
    playerctl # media player controller
    swaynotificationcenter # notifications manager

    # screenshots
    grim
    slurp

    wdisplays
    waypipe
    wev
    wf-recorder
    wl-clipboard
    wl-mirror
    wlr-randr
    wtype
  ];

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
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :0";
      StandardOutput = "journal";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  home.file.".config/niri/config.kdl".text = lib.strings.concatStringsSep "\n" [
    (import ./niri/shared.nix { inherit pkgs; })
    (import ./niri/${hostname}.nix)
  ];

  services.swayosd = {
    enable = true;
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
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
  };

  programs.waybar = {
    enable = true;
    settings.main = {
      layer = "top";
      margin = "6 8.5 6 8.5";
      spacing = 6;

      modules-left = [
        "custom/swaync"
        "custom/spotify"
      ];

      "custom/swaync" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          none = "󰂜";
          notification = "<span foreground='red'><sup></sup></span>";
          none-cc-open = "󰂚";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      "custom/spotify" = {
        tooltip = false;
        exec-if = "pgrep spotify";
        exec = "playerctl -p spotify -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
        format = "  {}";
        return-type = "json";
        on-click = "playerctl -p spotify play-pause";
        on-scroll-up = "playerctl -p spotify next";
        on-scroll-down = "playerctl -p spotify previous";
      };

      modules-center = [
        "clock"
      ];

      clock = {
        tooltip = false;
        format = "{:%b %d  //  %H:%M}";
        interval = 60;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "battery"
      ];

      tray = {
        icon-size = 18;
        spacing = 8;
      };

      pulseaudio = {
        format = "{icon}  {volume}%  {format_source}";
        format-bluetooth = "{icon}  {volume}%  {format_source}";
        format-bluetooth-muted = "󰝟 {icon}  {format_source}";
        format-icons = {
          car = "󰄋";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          hands-free = "󰗋";
          headphone = "󰋋";
          headset = "󰋎";
          phone = "󰏲";
          portable = "󰄜";
        };
        format-muted = "󰝟 {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        on-click = "pwvucontrol";
        scroll-step = 1;
      };

      "pulseaudio#mic" = {
        format = "{format_source}";
        format-source = "";
        format-source-muted = "󰍭";
        tooltip-format = "{volume}% {format_source}";
        on-click = "pavucontrol";
        on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 1%+";
        on-scroll-down = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 1%-";
      };

      network = {
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "󰌙  Disconnected";
        format-ethernet = "󰈀  {ipaddr}/{cidr}";
        format-linked = "󰌚  {ifname} (No IP)";
        format-wifi = "   {essid}";
        tooltip-format = "󰌘  {ifname} via {gwaddr}";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "<b>{capacity}% {icon} </b>";
        format-full = "<span color='#82A55F'><b>{capacity}% {icon}</b></span>";
        format-icons = [
          "󰁻"
          "󰁻"
          "󰁼"
          "󰁼"
          "󰁾"
          "󰁾"
          "󰂀"
          "󰂀"
          "󰂂"
          "󰂂"
          "󰁹"
        ];
        tooltip-format = "{timeTo} | {power} W";
        interval = 5;
      };
    };

    style = ''
      * {
        font-family: ${interface_font};
        font-size: 16px;
        font-weight: 600;
      }

      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        background: transparent;
      }

      #custom-swaync,
      #custom-spotify,
      #tray,
      #pulseaudio,
      #network,
      #battery,
      #clock {
        border-radius: 4px;
        background-color: rgba(0, 0, 0, 0.5);
        color: rgba(200, 200, 200, 0.9);
        padding: 0.5rem 0.85rem;
      }

      #custom-swaync {
        min-width: 1.6rem;
      }

      #custom-swaync menu,
      #tray menu {
        background: rgb(30, 30, 30);
        color: rgb(250, 250, 250);
      }
    '';
  };

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
}
