{
  config.programs.waybar = {
    settings.main = {
      "custom/power_menu" = {
        format = "⏻";
        on-click = "wlogout -b 4";
        tooltip-format = "Power Menu";
      };
    };
    style = ''
      #custom-power_menu {
      	padding: 0 12px;
      	font-size: 18px;
      }
      #custom-power_menu:hover {
      	background-color: @hover-bg;
      }
    '';
  };
}
