{
  config = {
    programs.waybar = {
      settings.main = {
        "custom/distro" = {
          format = "󱄅";
          tooltip = false;
        };
      };
      style = ''
        #custom-distro {
        	padding: 4px 8px 2px 8px;
        	font-size: 16pt;
        	background-color: @accent;
        	color: @main-bg;
        }
      '';
    };
  };
}
