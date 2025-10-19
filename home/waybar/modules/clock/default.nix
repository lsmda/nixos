{ config, ... }:

let
  theme = config.machine.theme;
in

{
  config.programs.waybar = {
    settings.main = {
      "group/clock" = {
        orientation = "horizontal";
        modules = [
          "clock#calendar"
          "custom/separator"
          "clock"
          "clock#offset"
        ];
      };

      "clock#calendar" = {
        format = "{:%Y-%m-%d}";
        min-length = 10;
        max-length = 10;
        tooltip-format = "{calendar}";
        calendar = {
          mode = "month";
          mode-mon-col = 6;
          format =
            let
              fontSize = "11.8pt";
            in
            {
              months = "<span font_size='${fontSize}' alpha='100%'><b>{}</b></span>";
              days = "<span font_size='${fontSize}' alpha='90%'>{}</span>";
              today = "<span font_size='${fontSize}' alpha='100%' background='#${theme.lavender}' color='#${theme.crust}'><b>{}</b></span>";
              weekdays = "<span font_size='${fontSize}' alpha='80%'><i>{}</i></span>";
            };
        };
        actions = {
          on-click = "mode";
        };
      };

      "custom/separator" = {
        min-length = 2;
        max-length = 2;
        format = "T";
        tooltip = false;
      };

      "clock" = {
        format = "{:%R}";
        tooltip = false;
      };

      "clock#offset" = {
        min-length = 6;
        max-length = 6;
        format = "{:%z}";
        tooltip = false;
      };
    };
    style = ''
      #clock.calendar:hover {
      	color: @hover-fg;
      }
      #clock.offset,
      #custom-separator {
        color: @secondary-fg;
      }
    '';
  };
}
