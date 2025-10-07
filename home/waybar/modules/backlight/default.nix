{ pkgs, ... }:

let
  backlightScript = pkgs.writeScript "backlight.sh" (builtins.readFile ./script.sh);
in

{
  config = {
    programs.waybar = {
      settings.main = {
        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          min-length = 7;
          max-length = 7;
          on-scroll-up = "${backlightScript} up";
          on-scroll-down = "${backlightScript} down";
          tooltip = false;
        };
      };
      style = ''
        #custom-left_div.7 {
        	background-color: @volume;
        	color: @backlight;
        }
        #backlight {
        	background-color: @backlight;
        }
      '';
    };
  };
}
