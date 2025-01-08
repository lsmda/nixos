let
  color = import ../themes/metal;
  theme = import ../modules/theme.nix;
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
        on-click = "activate";

        format-icons.active = "";
        format-icons.urgent = "";
        format-icons.default = "";
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
        "bluetooth"
        "network"
        "battery"
        "clock"
      ];

      tray = {
        reverse-direction = false;
        spacing = 8;
      };

      pulseaudio = {
        format = "{format_source} {icon} {volume}%";
        format-muted = "{format_source} 󰸈 {volume}%";

        format-source = "󰍬";
        format-source-muted = "󰍭";

        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
      };

      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "󰂱 {num_connections} connected";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "blueman-manager";
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
      font-family: "JetBrainsMono Nerd Font";
      opacity: .98;
    }

    .modules-right {
      margin-right: ${toString 10}px;
    }

    #waybar {
      background: ${color.base00};
      border-radius: ${toString theme.radius}px;
      color: ${color.base05};
    }

    #workspaces button {
      color: ${color.base05};
    }

    #workspaces button:hover {
      box-shadow: inherit;
      text-shadow: inherit;
      background: transparent;
    }

    #workspaces button.empty {
      color: ${color.base02};
    }

    #workspaces button.active.empty {
      color: ${color.base05};
    }

    #tray, #pulseaudio, #bluetooth, #network, #battery, #clock {
      margin-left: 15px;
    }

    #pulseaudio.muted, #bluetooh.disabled {
      color: ${color.base0D};
    }

    #battery.charging {
      color: ${color.base0B};
    }

    #battery.critical:not(.charging) {
      color: ${color.base08};
    }
  '';
}
