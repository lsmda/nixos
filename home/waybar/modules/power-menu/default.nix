{ pkgs, ... }:

let
  powerMenuScript = pkgs.writeScript "power-menu.sh" (builtins.readFile ./script.sh);
in

{
  config = {
    programs.waybar = {
      settings.main = {
        "custom/power_menu" = {
          format = "󰤄";
          on-click = "ghostty -e ${powerMenuScript}";
          tooltip-format = "Power Menu";
        };
      };
      style = ''
        #custom-power_menu {
        	padding: 0 16px;
        	font-size: 20px;
        	color: @accent;
        }
        #custom-power_menu:hover {
        	background-color: @hover-bg;
        }
      '';
    };
  };
}
