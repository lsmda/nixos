{ config, ... }:

let
  theme = config.machine.theme;
in

{
  config.programs.waybar = {
    settings.main = {
      "clock" = {
        format = "{:%R}";
        min-length = 5;
        max-length = 5;
        tooltip-format = "UTC Offset: {:%z}";
      };
      "clock#calendar" = {
        format = "󰸗 {:%Y-%m-%d}";
        min-length = 13;
        max-length = 13;
        tooltip-format = "{calendar}";
        calendar = {
          mode = "month";
          mode-mon-col = 6;
          format = {
            months = "<span alpha='100%'><b>{}</b></span>";
            days = "<span alpha='90%'>{}</span>";
            today = "<span alpha='100%' background='#${theme.lavender}' color='#${theme.crust}'><b>{}</b></span>";
            weekdays = "<span alpha='80%'><i>{}</i></span>";
          };
        };
        actions = {
          on-click = "mode";
        };
      };
      style = '''';
    };
  };
}
