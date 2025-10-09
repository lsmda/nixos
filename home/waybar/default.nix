{ config, ... }:

let
  theme = config.machine.theme;
in

{
  imports = [
    ../../system/theme

    ./modules/backlight
    ./modules/battery
    ./modules/clock
    ./modules/cpu
    ./modules/distro
    ./modules/memory
    ./modules/mpris
    ./modules/power-menu
    ./modules/temperature
    ./modules/tray
    ./modules/wireplumber
  ];

  config.programs.waybar = {
    enable = true;
    settings.main = {
      "modules-left" = [
        "mpris"
      ];

      "modules-center" = [
        "temperature"
        "memory"
        "cpu"
        "custom/distro"
        "clock"
        "clock#calendar"
      ];

      "modules-right" = [
        "tray"
        "group/wireplumber"
        "backlight"
        "battery"
        "custom/power_menu"
      ];

      layer = "top";
      height = 35;
      width = 0;
      margin = "6";
      spacing = 4;
      mode = "dock";
      reload_style_on_change = true;
    };
    style = ''
      @define-color accent     #${theme.lavender};
      @define-color main-br	   #${theme.subtext0};
      @define-color main-bg	   #${theme.crust};
      @define-color main-fg	   #${theme.text};
      @define-color hover-bg   #${theme.base};
      @define-color hover-fg   alpha(@main-fg, 0.75);
      @define-color outline	   shade(@main-bg, 0.5);
      @define-color warning	   #${theme.yellow};
      @define-color critical   #${theme.red};
      @define-color charging   #${theme.green};
              
      * {
      	font-family: "Berkeley Mono";
      	font-weight: 600;
      	font-size: 16px;
      	color: @main-fg;
      }

      window#waybar {
        border-radius: 5px;
      	background-color: @main-bg;
      }

      #custom-theme_switcher:hover,
      #idle_inhibitor:hover,
      #clock.calendar:hover,
      #network:hover,
      #bluetooth:hover,
      #custom-system_update:hover,
      #mpris:hover,
      #tray:hover,
      #pulseaudio:hover,
      #wireplumber:hover {
      	color: @hover-fg;
      }

      #pulseaudio.output.muted,
      #pulseaudio.input.source-muted,
      #wireplumber.muted
      .deactivated,
      .paused {
      	color: @hover-fg;
      }

      .warning { color: @warning; }
      .critical { color: @critical; }
      .charging { color: @charging; }

      button {
      	border-radius: 16px;
      	padding: 0 10px;
      }
      button:hover {
      	background-color: @hover-bg;
      	color: @hover-fg;
      }

      tooltip, #tray menu {
      	border: 2px solid @main-br;
      	border-radius: 10px;
      	background-color: @main-bg;
      }
      tooltip label {
      	margin: 2px 4px;
      	font-weight: normal;
      }
      tooltip decoration {
      	border: none;
      	background-color: transparent;
      }
    '';
  };
}
