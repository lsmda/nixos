{
  config.programs.waybar = {
    settings.main = {
      tray = {
        icon-size = 17;
        spacing = 8;
        cursor = true;
      };
    };
    style = ''
      #tray {
        margin-left: 10px;
        margin-right: 10px;
      }
      #tray menu {
        margin-left: 20px;
        margin-right: 20px;
      }
    '';
  };
}
