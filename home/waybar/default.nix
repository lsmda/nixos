{ config, ... }:

let
  theme = config.machine.theme;
in

{
  imports = [
    ../../system/theme

    ./modules/backlight
    ./modules/battery
    ./modules/bluetooth
    ./modules/clock
    ./modules/cpu
    ./modules/distro
    ./modules/memory
    ./modules/mpris
    ./modules/network
    ./modules/power-menu
    ./modules/pulseaudio
    ./modules/temperature
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
        "clock#time"
        "clock#date"
        "network"
        "bluetooth"
      ];

      "modules-right" = [
        "group/pulseaudio"
        "backlight"
        "battery"
        "custom/power_menu"
      ];

      layer = "top";
      height = 35;
      width = 0;
      margin = "6";
      spacing = 0;
      mode = "dock";
      reload_style_on_change = true;
    };
    style = ''
      @define-color rosewater		#${theme.rosewater};
      @define-color flamingo		#${theme.flamingo};
      @define-color pink			#${theme.pink};
      @define-color mauve			#${theme.mauve};
      @define-color red			#${theme.red};
      @define-color maroon		#${theme.maroon};
      @define-color peach			#${theme.peach};
      @define-color yellow		#${theme.yellow};
      @define-color green			#${theme.green};
      @define-color teal			#${theme.teal};
      @define-color sky			#${theme.sky};
      @define-color sapphire		#${theme.sapphire};
      @define-color blue			#${theme.blue};
      @define-color lavender		#${theme.lavender};
      @define-color text			#${theme.text};
      @define-color subtext1		#${theme.subtext1};
      @define-color subtext0		#${theme.subtext0};
      @define-color overlay2		#${theme.overlay2};
      @define-color overlay1		#${theme.overlay1};
      @define-color overlay0		#${theme.overlay0};
      @define-color surface2		#${theme.surface2};
      @define-color surface1		#${theme.surface1};
      @define-color surface0		#${theme.surface0};
      @define-color base			#${theme.base};
      @define-color mantle		#${theme.mantle};
      @define-color crust			#${theme.crust};

      /*
      	br - border
      	bg - background
      	fg - foreground
      */

      /* main colors */

      @define-color accent		@lavender;
      @define-color main-br		@subtext0;
      @define-color main-bg		@crust;
      @define-color main-fg		@text;
      @define-color hover-bg	@base;
      @define-color hover-fg	alpha(@main-fg, 0.75);
      @define-color outline		shade(@main-bg, 0.5);

      /* module colors */

      @define-color workspaces	@mantle;
      @define-color temperature	@mantle;
      @define-color memory      @base;
      @define-color cpu   			@surface0;
      @define-color time		  	@surface0;
      @define-color date			  @base;
      @define-color tray			  @mantle;
      @define-color volume		  @mantle;
      @define-color backlight		@base;
      @define-color battery		  @surface0;

      /* state colors */

      @define-color warning		@yellow;
      @define-color critical  @red;
      @define-color charging	@green;
              
      /* ----------------------- */
      /* -------- style -------- */
      /* ----------------------- */

      * {
      	font-family: "Berkeley Mono";
      	font-weight: bold;
      	font-size: 16px;
      	color: @main-fg;
      }

      window {
      	background-color: transparent;
      }

      window#waybar {
        border-radius: 5px;
      	background-color: @main-bg;
      }

      /* hoverables */

      #custom-theme_switcher:hover,
      #idle_inhibitor:hover,
      #clock.date:hover,
      #network:hover,
      #bluetooth:hover,
      #custom-system_update:hover,
      #mpris:hover,
      #pulseaudio:hover,
      #wireplumber:hover {
      	color: @hover-fg;
      }

      /* states */

      .deactivated,
      .paused,
      #pulseaudio.output.muted,
      #pulseaudio.input.source-muted,
      #wireplumber.muted {
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

      tooltip {
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
