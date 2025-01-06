let
  color = import ../themes/metal;
in

{
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;

  programs.waybar.settings = [
    {
      layer = "top";
      height = 40;

      margin-right = 8;
      margin-left = 8;
      margin-top = 8;
      margin-bottom = 0;

      modules-left = [ "hyprland/workspaces" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons.default = "";
        format-icons.active = "";
        format-icons.empty = "";

        persistent-workspaces."*" = 4;
      };

      modules-center = [
        "hyprland/window"
      ];

      "hyprland/window" = {
        format = "{}";
        max-length = 42;
        rewrite = {
          ".* — Mozilla Firefox" = "Firefox";
          ".* - Chromium" = "Chromium";
          "Microsoft Teams .*" = "Microsoft Teams";
          "Spotify Premium" = "Spotify";
        };
      };

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "battery"
        "clock"
      ];

      tray = {
        reverse-direction = true;
        spacing = 8;
      };

      pulseaudio = {
        format = "{format_source} {icon} {volume}%";
        format-muted = "{format_source} 󰸈";

        format-bluetooth = "{format_source} 󰋋 󰂯 {volume}%";
        format-bluetooth-muted = "{format_source} 󰟎 󰂯";

        format-source = "󰍬";
        format-source-muted = "󰍭";

        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
      };

      network = {
        format-disconnected = "󰤮 ";
        format-ethernet = "󰈀 {ipaddr}/{cidr}";
        format-linked = " {ifname} (No IP)";
        format-wifi = "  {essid}";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = "{icon} {capacity}%";
        format-plugged = "{icon} {capacity}%";

        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];

        states.warning = 30;
        states.critical = 15;
      };

      clock.tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    }
  ];

  programs.waybar.style = ''
    * {
      border: none;
      border-radius: ${toString 8}px;
      font-family: "JetBrainsMono Nerd Font";
      opacity: .9;
    }

    .modules-right {
      margin-right: ${toString 5}px;
    }

    #waybar {
      background: ${color.base00};
      color: ${color.base05};
    }

    #workspaces button {
      color: ${color.base05};
    }

    #workspaces button.empty {
      color: ${color.base02};
    }

    #workspaces button.active.empty {
      color: ${color.base05};
    }

    #tray, #pulseaudio, #network, #battery, #clock {
      margin-left: 15px;
    }

    #battery.charging {
      color: ${color.base0B};
    }

    #battery.critical:not(.charging) {
      color: ${color.base08};
    }
  '';
}
