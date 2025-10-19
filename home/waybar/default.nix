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
    ./modules/power
    ./modules/temperature
    ./modules/tray
    ./modules/wireplumber
  ];

  config.programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "niri.service";
    };

    settings.main = {
      "modules-left" = [
        "temperature"
        "memory"
        "cpu"
        "mpris"
      ];

      "modules-center" = [
        "group/clock"
      ];

      "modules-right" = [
        "tray"
        "wireplumber#output"
        "wireplumber#input"
        "backlight"
        "battery"
        "custom/power"
      ];

      layer = "top";
      name = "main";
      height = 30;
      margin = "6";
      reload_style_on_change = true;
    };
    style = ''
      @define-color accent #${theme.lavender};
      @define-color main-br #${theme.subtext0};
      @define-color main-bg #${theme.crust};
      @define-color main-fg #${theme.text};
      @define-color secondary-fg alpha(@main-fg, 0.6);
      @define-color hover-bg #${theme.base};
      @define-color outline shade(@main-bg, 0.5);
      @define-color warning #${theme.yellow};
      @define-color critical #${theme.red};
      @define-color charging #${theme.green};

      * {
        min-height: 0;
        text-shadow: none;
      	font-family: Berkeley Mono;
      	color: @main-fg;
      	border-radius: 16px;
      }

      window#waybar {
        padding: 0 20px;
        font-size: 11pt;
      	font-weight: 400;
      	background-color: @main-bg;
      	border: 2px solid @main-bg;
      	border-radius: 10px;
      }

      .paused,
      .deactivated,
      #mpris:hover,
      #wireplumber:hover,
      #wireplumber.output.muted,
      #wireplumber.input.source-muted {
      	color: @hover-fg;
      }

      .warning {
        color: @warning;
      }

      .critical {
        color: @critical;
      }

      .charging {
        color: @charging;
      }

      button {
      	border-radius: 16px;
      	padding: 0 10px;
      }

      button:hover {
      	color: @hover-fg;
      }

      menu,
      tooltip {
      	border: 2px solid @main-br;
      	border-radius: 8px;
      	background-color: @main-bg;
        padding: 2px;
      }

      menuitem {
        padding: 8px 4px;
        border-radius: 8px;
      }

      menuitem:hover {
        background-color: @hover-bg;
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
